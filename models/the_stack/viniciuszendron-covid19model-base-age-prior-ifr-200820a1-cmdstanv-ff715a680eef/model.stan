// model 1:
// Binomial using casesU as total
// and p specified by age at midpoint

functions {
    real model_1_log_dens(
        array[] int deaths_slice,
        int start,
        int end,
        //pars
        vector logit_p_avg,
        // data
        array[] int casesU
        )
    {
        int n;
        real lpmf;
        int N_slice;
        
        lpmf = 0.0;
        N_slice = end - start + 1;
        for(n_slice in 1:N_slice)
        {
            n = n_slice + start - 1;
            lpmf += binomial_logit_lpmf(deaths_slice[n] | casesU[n], logit_p_avg[n]);
        }
        return( lpmf );
    }
}

data {
  int<lower=0> N; // number of observations
  int<lower=0> N_predict; // number of predictions
  int<lower=0> M; // number of studies
  array[N] int deaths; // number of deaths
  array[N] int casesU; //  upper bound cases
  array[N] int casesL; // lower bound cases
  vector<lower=0>[N_predict] age; //  age predictions
  vector<lower=0>[N] age_study; //  age midpoints
  array[N] int lower_age_idx; // lower index of observed age band in age_predict
  array[N] int upper_age_idx; // upper index of observed age band in age_predict
  array[N] int<lower=1,upper=M> study;
  int max_casesN;
  //matrix[max_casesN, N] log_choose_fct;
  //matrix[max_casesN, N] auxCases;
}

parameters {
  real alpha;
  real beta;
  real<lower=0> study_rnde_sd;
  vector[M] study_rnde;
}

transformed parameters
{
    vector<upper=0>[N] log_p_avg;
    vector[N] logit_p_avg;
    
    log_p_avg =  alpha + beta * age_study;
    logit_p_avg = logit(exp(log_p_avg));
    logit_p_avg += study_rnde[ study ];
}

model
{
    target += normal_lpdf( alpha | 0, 10);
    target += normal_lpdf( beta | 0, 1);
    target += normal_lpdf( study_rnde | 0, study_rnde_sd);
    target += exponential_lpdf( study_rnde_sd | 10);

    //log lkl rstan version
    target += model_1_log_dens(deaths, 1, N,
    //log lkl cmdstan version
    //target += reduce_sum(model_1_log_dens, deaths, 1,
        logit_p_avg,
        casesU
        );
}


