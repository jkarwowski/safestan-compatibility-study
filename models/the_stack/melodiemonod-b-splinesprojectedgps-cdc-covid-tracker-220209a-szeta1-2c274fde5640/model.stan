functions {
    matrix kron_mvprod(matrix A, matrix B, matrix V) 
    {
        return transpose(A*transpose(B*V));
    }
    
  matrix gp(int N_rows, int N_columns, array[] real rows_idx, array[] real columns_index,
            real delta0,
            real zeta_gp, 
            real gamma_gp1, real gamma_gp2,
            matrix z1)
  {
    
    matrix[N_rows,N_columns] GP;
    
    matrix[N_rows, N_rows] K1;
    matrix[N_rows, N_rows] L_K1;
    
    matrix[N_columns, N_columns] K2;
    matrix[N_columns, N_columns] L_K2;
    
    K1 = gp_exp_quad_cov(rows_idx, sqrt(zeta_gp), gamma_gp1) + diag_matrix(rep_vector(delta0, N_rows));
    K2 = gp_exp_quad_cov(columns_index, sqrt(zeta_gp), gamma_gp2) + diag_matrix(rep_vector(delta0, N_columns));

    L_K1 = cholesky_decompose(K1);
    L_K2 = cholesky_decompose(K2);
    
    GP = kron_mvprod(L_K2, L_K1, z1);

    return(GP);
  }
}

data{
  int<lower=1> W; // number of weeks 
  int<lower=1> M; // number of states 
  int<lower=0> A; // continuous age
  int<lower=0> B; // first age band specification
  int<lower=0,upper=W> W_OBSERVED; // number of weeks observed 
  int<lower=0,upper=W> W_NOT_OBSERVED; // number of weeks not observed 
  array[W_OBSERVED] int<lower=1, upper=W> IDX_WEEKS_OBSERVED; // index of the weeks observed 
  array[W] int<lower=1, upper=W> IDX_WEEKS_OBSERVED_REPEATED; // index of the weeks observed where missing is equal to the previous one 
  array[M, W_OBSERVED] int<lower=0,upper=B> N_idx_non_missing;
  array[M, B, W_OBSERVED] int<lower=-1,upper=B> idx_non_missing; // indices non-missing deaths for W
  array[A] real age; // age continuous
  array[M, W_OBSERVED] real inv_sum_deaths; // inverse sum of deaths
  array[M] row_vector[W_OBSERVED] lambda_prior_parameters; // parameters of the prior distribution of lambda
  array[M, B, W_OBSERVED] int deaths; // daily deaths in age band b at time t
  array[B] int age_from_state_age_strata; // age from of age band b
  array[B] int age_to_state_age_strata;// age to of age band b
  
  // missing death count
  array[M] int<lower=0> N_missing; // number of missing series 
  array[M, max(N_missing)] int<lower=-1, upper=1> start_or_end_period; // is the serie cut by the end of the period
  array[M, max(N_missing)] int<lower=-1,upper=B> age_missing; // age index with the missing death count in the serie
  // int<lower=1,upper=W> N_weeks_missing[M,max(N_missing)]; // numbers weeks missing in each serie
  array[M, max(N_missing)] int<lower=-1,upper=W> idx_weeks_missing_min; // index of weeks missing in the series
  array[M, max(N_missing)] int<lower=-1,upper=W> idx_weeks_missing_max; // index of weeks missing in the series
  array[M, max(N_missing)] int<lower=-1> sum_count_censored; // sum of the missing deaths over the serie if it ends before the period
  array[M, max(N_missing)] int min_count_censored; // range of the censored data if it ends after the period
  array[M, max(N_missing)] int max_count_censored; // range of the censored data if it ends after the period
  
  //splines
  int num_basis_rows;
  int num_basis_columns;
  matrix[num_basis_rows, A] BASIS_ROWS; 
  matrix[num_basis_columns, W] BASIS_COLUMNS; 
  
  // GP
  array[num_basis_rows] real IDX_BASIS_ROWS;
  array[num_basis_columns] real IDX_BASIS_COLUMNS;
}

transformed data
{   
    real delta0 = 1e-9;  
    int N_log_lik = 0;
    
  for(m in 1:M){
    for(w in 1:W_OBSERVED){
      for(i in idx_non_missing[m][1:N_idx_non_missing[m][w],w]){
        N_log_lik += 1;
      }
    }
 
   for(n in 1:N_missing[m]){
     if(!start_or_end_period[m][n])
     {
        N_log_lik += 1;
 
     } else {
        for(i in min_count_censored[m][n]:max_count_censored[m][n])
           N_log_lik += 1;
     }
    }
  }

}

parameters {
  array[M] real<lower=0> nu_inverse;
  array[M] vector<lower=0>[W-W_NOT_OBSERVED] lambda_raw;
  array[M] matrix[num_basis_rows, num_basis_columns] z1;
  array[M] real<lower=0> zeta_gp;
  array[M] real<lower=0> gamma_gp1; 
  array[M] real<lower=0> gamma_gp2;
}

transformed parameters {
  array[M] vector<lower=0>[W] lambda;
  array[M] real<lower=0> nu;
  array[M] matrix[A, W] phi;
  array[M] matrix[A, W] alpha;
  array[M] matrix[B, W] phi_reduced;
  array[M] matrix[B, W] alpha_reduced;
  array[M] matrix[num_basis_rows, num_basis_columns] beta; 
  array[M] matrix[A, W] f;

  for(m in 1:M){
    lambda[m] = lambda_raw[m][IDX_WEEKS_OBSERVED_REPEATED];
    nu[m] = (1/nu_inverse[m]);

    beta[m] = gp(num_basis_rows, num_basis_columns, IDX_BASIS_ROWS, IDX_BASIS_COLUMNS, delta0,
              zeta_gp[m], gamma_gp1[m],  gamma_gp2[m], z1[m]);

    f[m] = (BASIS_ROWS') * beta[m] * BASIS_COLUMNS;
    
    for(w in 1:W){
      phi[m][:,w] = softmax( f[m][:,w] ); 
      alpha[m][:,w] = phi[m][:,w] * lambda[m][w] / nu[m] ;
      
      for(b in 1:B){
        alpha_reduced[m][b,w] = sum(alpha[m][age_from_state_age_strata[b]:age_to_state_age_strata[b], w]);
        phi_reduced[m][b,w] = sum(phi[m][age_from_state_age_strata[b]:age_to_state_age_strata[b], w]);
      }
    }
  }
  
}

model {
  
  nu_inverse ~ normal(0,5);

  // sensitivity analysis 1 on zeta
  zeta_gp ~ cauchy(0,10);
  
  gamma_gp1 ~ inv_gamma(2, 2);
  gamma_gp2 ~ inv_gamma(2, 2);

  for(i in 1:num_basis_rows){
    for(j in 1:num_basis_columns){
      z1[:,i,j] ~ normal(0,1);
    }
  }
  

  for(m in 1:M){
    
    lambda_raw[m] ~ exponential( rep_row_vector(1.0, W_OBSERVED) ./lambda_prior_parameters[m] ); 


    // Note on the neg bin parametrisation related to the paper:
    // mean neg_binomial_lpmf is alpha_reduced / nu_inverse = alpha_reduced * nu
    // var neg_binomial_lpmf is alpha_reduced / nu_inverse^2 * (nu_inverse + 1) = alpha_reduced * nu (1 + nu)
    
    for(w in 1:W_OBSERVED){
      
      array[N_idx_non_missing[m][w]] int indx_w_m = idx_non_missing[m][1:N_idx_non_missing[m][w],w];
      target += neg_binomial_lpmf(deaths[m][indx_w_m,w] | alpha_reduced[m][indx_w_m, IDX_WEEKS_OBSERVED[w]] , nu_inverse[m] );
        
    }

    for(n in 1:N_missing[m]){
      real alpha_reduced_missing = sum(alpha_reduced[m][ age_missing[m][n], idx_weeks_missing_min[m][n]:idx_weeks_missing_max[m][n] ]);

      if(!start_or_end_period[m][n])
      {
        target += neg_binomial_lpmf( sum_count_censored[m][n] | alpha_reduced_missing , nu_inverse[m] ) ;
      } 
      else {
       for(i in min_count_censored[m][n]:max_count_censored[m][n])
          target += neg_binomial_lpmf( i | alpha_reduced_missing , nu_inverse[m] ) ;
      }
    } 

  }


}

generated quantities {
  array[N_log_lik] real log_lik;
  array[M, A, W] int deaths_predict;
  array[M, B, W] int deaths_predict_state_age_strata;
  
    // predction and log likelihood for the weekly age model
  {
    int idx_log_lik = 0;
        
    for(m in 1:M){


        for(w in 1:W){
            // predict deaths
            deaths_predict[m,:,w] = neg_binomial_rng(alpha[m,:,w], nu_inverse[m] );
            deaths_predict_state_age_strata[m,:,w] = neg_binomial_rng(alpha_reduced[m,:,w], nu_inverse[m] );
        }

        for(w in 1:W_OBSERVED){
            for(i in idx_non_missing[m][1:N_idx_non_missing[m][w],w]){
                idx_log_lik += 1;
                log_lik[idx_log_lik] = neg_binomial_lpmf(deaths[m,i,w] | alpha_reduced[m,i, IDX_WEEKS_OBSERVED[w]] , nu_inverse[m] );
            }
        }

        for(n in 1:N_missing[m]){
            real alpha_reduced_missing = sum(alpha_reduced[m][ age_missing[m][n], idx_weeks_missing_min[m][n]:idx_weeks_missing_max[m][n] ]);

            if(!start_or_end_period[m][n])
                {
                idx_log_lik += 1;
                log_lik[idx_log_lik] = neg_binomial_lpmf( sum_count_censored[m][n] | alpha_reduced_missing , nu_inverse[m] ) ;
            } else {
                for(i in min_count_censored[m][n]:max_count_censored[m][n]){
                    idx_log_lik += 1;
                    log_lik[idx_log_lik] = neg_binomial_lpmf( i | alpha_reduced_missing , nu_inverse[m] ) ;
                }
            }
        }
    }
  }


}


