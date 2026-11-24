functions {
    matrix kron_mvprod(matrix A, matrix B, matrix V) 
    {
        return transpose(A*transpose(B*V));
    }
    
  matrix gp(int N_rows, int N_columns, array[] real rows_idx, array[] real columns_index,
            real delta0,
            real alpha_gp, 
            real rho_gp1, real rho_gp2,
            matrix z1)
  {
    
    matrix[N_rows,N_columns] GP;
    
    matrix[N_rows, N_rows] K1;
    matrix[N_rows, N_rows] L_K1;
    
    matrix[N_columns, N_columns] K2;
    matrix[N_columns, N_columns] L_K2;
    
    K1 = gp_exp_quad_cov(rows_idx, sqrt(alpha_gp), rho_gp1) + diag_matrix(rep_vector(delta0, N_rows));
    K2 = gp_exp_quad_cov(columns_index, sqrt(alpha_gp), rho_gp2) + diag_matrix(rep_vector(delta0, N_columns));

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
  array[M] matrix[2, W_OBSERVED] lambda_prior_parameters; // parameters of the prior distribution of lambda
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
  
  // JHU data
  matrix[M,W] deaths_JHU; // deaths reported by JHU

  // GP
  array[W] real IDX_WEEKS;

  // vaccine effect
  array[M] int<lower=1,upper=W> w_stop_resurgence; // index of the week when Summer 2021 resurgences stop
  array[M] int<lower=1,upper=W> w_start_resurgence; // index of the week when Summer 2021 resurgences starts
  int<lower=1> T; // number of weeks during the Summer 2021 resurgences (w_stop_resurgence-w_start_resurgence+1)
  vector[T] week_indices_resurgence; // 0:(T-1)
  int<lower=1> C; // number of age groups in vaccination data
  array[C] int age_from_vac_age_strata; // age from of age band c
  array[C] int age_to_vac_age_strata;// age to of age band c
  array[C] row_vector[M] prop_vac_start; // pre-resurgence proportion of vaccinated individuals
  array[C] row_vector[M] prop_vac_start_counterfactual; // pre-resurgence proportion of vaccinated individuals
  
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
  array[M] real<lower=0> nu_unscaled;
  array[M] vector<lower=0>[W-W_NOT_OBSERVED] lambda_raw;
  array[M] matrix[W, A] z1;
  array[M] real<lower=0> alpha_gp;
  array[M] real<lower=0> rho_gp1; 
  array[M] real<lower=0> rho_gp2;

  array[C] real intercept_resurgence0;
  array[C] row_vector[M] intercept_resurgence_re;
  array[C] real<lower=0> sigma_intercept_resurgence;
  array[C] real slope_resurgence0;
  array[C] real vaccine_effect_intercept_cross;
  array[C] real vaccine_effect_slope_cross;
  real vaccine_effect_intercept_diagonal;
  real vaccine_effect_slope_diagonal;
  array[M] real<lower=0> sigma_r_pdeaths;
}

transformed parameters {
  array[M] vector<lower=0>[W] lambda;
  array[M] real<lower=0> nu;
  array[M] real<lower=0> theta;
  array[M] matrix[A, W] phi;
  array[M] matrix[A, W] alpha;
  array[M] matrix[B, W] phi_reduced;
  array[M] matrix[C, W] phi_reduced_vac;
  array[M] matrix[B, W] alpha_reduced;
  array[M] matrix[A, W] f;
  array[C] row_vector[M] intercept_resurgence;
  array[C] row_vector[M] slope_resurgence;
  array[M] matrix[C, W] E_pdeaths;
  array[M] matrix[C, T] r_pdeaths;
  array[M] matrix[C, T] log_r_pdeaths;
  matrix[M,C] E_pdeaths_before_resurgence;
  array[C] matrix[T, M] xi;
  array[C] matrix[T, M] log_xi;

  for(m in 1:M){
    lambda[m] = lambda_raw[m][IDX_WEEKS_OBSERVED_REPEATED];
    nu[m] = (1/nu_unscaled[m])^2;
    theta[m] = (1 / nu[m]);

    f[m] = (gp(W, A, IDX_WEEKS, age, delta0, alpha_gp[m], rho_gp1[m],  rho_gp2[m], z1[m]))';

    for(w in 1:W){
      phi[m][:,w] = softmax( f[m][:,w] ); 
      alpha[m][:,w] = phi[m][:,w] * lambda[m][w] / nu[m] ;
      
      for(b in 1:B){
        alpha_reduced[m][b,w] = sum(alpha[m][age_from_state_age_strata[b]:age_to_state_age_strata[b], w]);
        phi_reduced[m][b,w] = sum(phi[m][age_from_state_age_strata[b]:age_to_state_age_strata[b], w]);
      }

      for(c in 1:C){
        phi_reduced_vac[m][c,w] = sum(phi[m][age_from_vac_age_strata[c]:age_to_vac_age_strata[c], w]);
        E_pdeaths[m][c,w] = phi_reduced_vac[m][c,w] * deaths_JHU[m,w];

        if(w == w_start_resurgence[m] - 1){
            E_pdeaths_before_resurgence[m,c] = (E_pdeaths[m][c,(w_start_resurgence[m] - 1)] + E_pdeaths[m][c,(w_start_resurgence[m] - 2)]) / 2;
        }

        if(w >= w_start_resurgence[m] && w <= w_stop_resurgence[m]){
            r_pdeaths[m][c,w - w_start_resurgence[m] + 1] = E_pdeaths[m][c,w] / max(E_pdeaths[m][c,1:(w_start_resurgence[m] - 1)]) ;
            log_r_pdeaths[m][c,w - w_start_resurgence[m] + 1] = log( r_pdeaths[m][c,w - w_start_resurgence[m] + 1] );
        }
        
      }
    }

    
  }
  
  for(c in 1:C){
    intercept_resurgence[c] = rep_row_vector(intercept_resurgence0[c], M) + intercept_resurgence_re[c];
    slope_resurgence[c] = rep_row_vector(slope_resurgence0[c], M) ;

    for(c_prime in 1:C){
      
      if(c_prime == c){
        intercept_resurgence[c] += prop_vac_start[c] .* rep_row_vector(vaccine_effect_intercept_diagonal, M);
        slope_resurgence[c] += prop_vac_start[c] .* rep_row_vector(vaccine_effect_slope_diagonal, M);
      } else{
        intercept_resurgence[c] += prop_vac_start[c_prime] .* rep_row_vector(vaccine_effect_intercept_cross[c_prime], M);
        slope_resurgence[c] += prop_vac_start[c_prime] .* rep_row_vector(vaccine_effect_slope_cross[c_prime], M);
      }
    }
    

    log_xi[c] = rep_matrix(intercept_resurgence[c], T) + rep_matrix(week_indices_resurgence, M) .* rep_matrix(slope_resurgence[c], T);
    xi[c] = exp(log_xi[c]);
  }
  
}

model {
  
  nu_unscaled ~ normal(0,1);

  alpha_gp ~ cauchy(0,1);
  rho_gp1 ~ inv_gamma(5, 5);
  rho_gp2 ~ inv_gamma(5, 5);

  intercept_resurgence0 ~ normal(0,0.5);
  slope_resurgence0 ~ normal(0,0.5);
  
  vaccine_effect_intercept_diagonal ~ normal(0,0.5);
  vaccine_effect_slope_diagonal ~ normal(0,0.5);
  vaccine_effect_intercept_cross ~ normal(0,0.5);
  vaccine_effect_slope_cross ~ normal(0,0.5);
    
  sigma_intercept_resurgence ~ cauchy(0,1);
  sigma_r_pdeaths ~ cauchy(0,1);

  for(c in 1:C){
    intercept_resurgence_re[c] ~ normal(0,sigma_intercept_resurgence[c]);
  }

  for(i in 1:W){
    for(j in 1:A){
      z1[:,i,j] ~ normal(0,1);
    }
  }
  

  for(m in 1:M){
    
    lambda_raw[m] ~ gamma( lambda_prior_parameters[m][1,:],lambda_prior_parameters[m][2,:]);


    for(w in 1:W_OBSERVED){
      
      array[N_idx_non_missing[m][w]] int indx_w_m = idx_non_missing[m][1:N_idx_non_missing[m][w],w];
      target += neg_binomial_lpmf(deaths[m][indx_w_m,w] | alpha_reduced[m][indx_w_m, IDX_WEEKS_OBSERVED[w]] , theta[m] );
        
    }

    for(n in 1:N_missing[m]){
      real alpha_reduced_missing = sum(alpha_reduced[m][ age_missing[m][n], idx_weeks_missing_min[m][n]:idx_weeks_missing_max[m][n] ]);

      if(!start_or_end_period[m][n])
      {
        target += neg_binomial_lpmf( sum_count_censored[m][n] | alpha_reduced_missing , theta[m] ) ;
      } 
      else {
       for(i in min_count_censored[m][n]:max_count_censored[m][n])
          target += neg_binomial_lpmf( i | alpha_reduced_missing , theta[m] ) ;
      }
    } 

    for(c in 1:C){
      r_pdeaths[m][c,:] ~ gamma(square(xi[c][:,m] / sigma_r_pdeaths[m]), xi[c][:,m] ./ rep_vector(square(sigma_r_pdeaths[m]), T) );
    }
  }


}

generated quantities {
  array[N_log_lik] real log_lik;
  array[M, A, W] int deaths_predict;
  array[M, B, W] int deaths_predict_state_age_strata;
  array[C] row_vector[M] intercept_resurgence_counterfactual;
  array[C] row_vector[M] slope_resurgence_counterfactual;
  array[M] matrix[C, T] log_r_pdeaths_counterfactual;
  array[M] matrix[C, T] r_pdeaths_counterfactual;
  array[M] matrix[C, T] log_r_pdeaths_predict;
  array[M] matrix[C, T] r_pdeaths_predict;
  array[C] matrix[T, M] xi_counterfactual;
  array[C] matrix[T, M] log_xi_counterfactual;
  array[M] matrix[C, T] E_pdeaths_counterfactual;
  array[M] matrix[C, T] E_pdeaths_counterfactual_resurgence_cumulative;
  array[M] matrix[C, T] E_pdeaths_predict;
  array[M] matrix[C, T] E_pdeaths_predict_resurgence_cumulative;
  array[M] matrix[C, T] E_pdeaths_resurgence_cumulative;
  matrix[C,T] E_pdeaths_resurgence_cumulative_all = rep_matrix(0, C, T);
  array[M] matrix[C, T] diff_E_pdeaths_counterfactual;
  array[M] matrix[C, T] perc_E_pdeaths_counterfactual;
  matrix[C,T] diff_E_pdeaths_counterfactual_all = rep_matrix(0, C, T);
  matrix[C,T] perc_E_pdeaths_counterfactual_all;
  {
    int idx_log_lik = 0;

    for(c in 1:C){
        intercept_resurgence_counterfactual[c] = rep_row_vector(intercept_resurgence0[c], M) + intercept_resurgence_re[c];
        slope_resurgence_counterfactual[c] = rep_row_vector(slope_resurgence0[c], M) ;

      for(c_prime in 1:C){
        if(c_prime == c){
          intercept_resurgence_counterfactual[c] += prop_vac_start_counterfactual[c] .* rep_row_vector(vaccine_effect_intercept_diagonal, M);
          slope_resurgence_counterfactual[c] += prop_vac_start_counterfactual[c] .* rep_row_vector(vaccine_effect_slope_diagonal, M);
        } else{
          intercept_resurgence_counterfactual[c] += prop_vac_start_counterfactual[c_prime] .* rep_row_vector(vaccine_effect_intercept_cross[c_prime], M);
          slope_resurgence_counterfactual[c] += prop_vac_start_counterfactual[c_prime] .* rep_row_vector(vaccine_effect_slope_cross[c_prime], M);
        }
      }
     log_xi_counterfactual[c] = rep_matrix(intercept_resurgence_counterfactual[c], T) +
                            rep_matrix(week_indices_resurgence, M) .* rep_matrix(slope_resurgence_counterfactual[c], T);
     xi_counterfactual[c] = exp(log_xi_counterfactual[c]);

    }


    for(m in 1:M){

        for(c in 1:C){
          
            r_pdeaths_predict[m][c,:] = to_row_vector( gamma_rng(square(xi[c][:,m] / sigma_r_pdeaths[m]), xi[c][:,m] ./ rep_vector(square(sigma_r_pdeaths[m]), T)  ) );
            log_r_pdeaths_predict[m][c,:] = log( r_pdeaths_predict[m][c,:] );
            E_pdeaths_predict[m][c,:] = rep_row_vector(max(E_pdeaths[m][c,1:(w_start_resurgence[m] - 1)]), T) .* r_pdeaths_predict[m][c,:] ;
            E_pdeaths_predict_resurgence_cumulative[m][c,:] = cumulative_sum(E_pdeaths_predict[m][c,:]);
            
            r_pdeaths_counterfactual[m][c,:] = to_row_vector( gamma_rng( square(xi_counterfactual[c][:,m] / sigma_r_pdeaths[m]), xi_counterfactual[c][:,m] ./ rep_vector(square(sigma_r_pdeaths[m]), T)) );
            log_r_pdeaths_counterfactual[m][c,:] = log( r_pdeaths_counterfactual[m][c,:] );
            E_pdeaths_counterfactual[m][c,:] = rep_row_vector(max(E_pdeaths[m][c,1:(w_start_resurgence[m] - 1)]), T) .* r_pdeaths_counterfactual[m][c,:] ;
            E_pdeaths_counterfactual_resurgence_cumulative[m][c,:] = cumulative_sum(E_pdeaths_counterfactual[m][c,:]);
            
            E_pdeaths_resurgence_cumulative[m][c,:] = cumulative_sum(E_pdeaths[m][c,w_start_resurgence[m]:w_stop_resurgence[m]]);
            
            diff_E_pdeaths_counterfactual[m][c,:] = E_pdeaths_predict_resurgence_cumulative[m][c,:] - E_pdeaths_counterfactual_resurgence_cumulative[m][c,:];
            perc_E_pdeaths_counterfactual[m][c,:] = diff_E_pdeaths_counterfactual[m][c,:] ./ E_pdeaths_predict_resurgence_cumulative[m][c,:] ;
            
            diff_E_pdeaths_counterfactual_all[c,:] += diff_E_pdeaths_counterfactual[m][c,:];
            E_pdeaths_resurgence_cumulative_all[c,:] += E_pdeaths_predict_resurgence_cumulative[m][c,:];
            
        }

        for(w in 1:W){
            // predict deaths
            deaths_predict[m,:,w] = neg_binomial_rng(alpha[m,:,w], theta[m] );
            deaths_predict_state_age_strata[m,:,w] = neg_binomial_rng(alpha_reduced[m,:,w], theta[m] );
        }

        for(w in 1:W_OBSERVED){
            for(i in idx_non_missing[m][1:N_idx_non_missing[m][w],w]){
                idx_log_lik += 1;
                log_lik[idx_log_lik] = neg_binomial_lpmf(deaths[m,i,w] | alpha_reduced[m,i, IDX_WEEKS_OBSERVED[w]] , theta[m] );
            }
        }

        for(n in 1:N_missing[m]){
            real alpha_reduced_missing = sum(alpha_reduced[m][ age_missing[m][n], idx_weeks_missing_min[m][n]:idx_weeks_missing_max[m][n] ]);

            if(!start_or_end_period[m][n])
                {
                idx_log_lik += 1;
                log_lik[idx_log_lik] = neg_binomial_lpmf( sum_count_censored[m][n] | alpha_reduced_missing , theta[m] ) ;
            } else {
                for(i in min_count_censored[m][n]:max_count_censored[m][n]){
                    idx_log_lik += 1;
                    log_lik[idx_log_lik] = neg_binomial_lpmf( i | alpha_reduced_missing , theta[m] ) ;
                }
            }
        }

    }
    perc_E_pdeaths_counterfactual_all = diff_E_pdeaths_counterfactual_all ./ E_pdeaths_resurgence_cumulative_all;

  }
  
    
}





