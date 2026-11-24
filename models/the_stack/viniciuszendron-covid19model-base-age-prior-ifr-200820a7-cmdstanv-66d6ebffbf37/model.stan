functions {

    real model_log_dens(
        array[] int deaths_slice,
        int start,
        int end,
        //pars
        vector logit_p_avg,
        // data
        array[] int casesM
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
            lpmf += binomial_logit_lpmf(deaths_slice[n] | casesM[n], logit_p_avg[n]);
        }
        return( lpmf );
    }
}

data
{
    int<lower=0> N; // number of observations
    int<lower=0> N_predict; // number of predictions
    int<lower=0> M; // number of studies
    array[N] int deaths; // number of deaths
    array[N] int casesM; // numnber of cases, midpoint estimate
    vector<lower=0>[N_predict] age; //  age predictions
    vector<lower=0>[N] age_study; //  age midpoints
    array[N] int<lower=1,upper=M> study;
}

parameters
{
    real alpha;
    real beta;
    real<lower=0> study_rnde_sd;
    vector[M] study_rnde;
}

transformed parameters
{
    vector[N] logit_p_avg;
    logit_p_avg = alpha + beta * age_study + study_rnde[study];
}

model
{
    target += normal_lpdf( alpha | 0, 20);
    target += normal_lpdf( beta | 0, 1);
    target += normal_lpdf( study_rnde | 0, study_rnde_sd);
    target += exponential_lpdf( study_rnde_sd | 10);

    //log lkl rstan version
    target += model_log_dens(deaths, 1, N,
    //log lkl cmdstan version
    //target += reduce_sum(model_log_dens, deaths, 1,
        // pars
        logit_p_avg,
        // data
        casesM
        );
}

generated quantities
{
    vector<lower=0, upper=1>[N_predict] p_predict;
    array[N_predict] int pred_deaths;
    
    p_predict = inv_logit( alpha + beta * age );
    pred_deaths = binomial_rng(rep_array(10000000, N_predict), p_predict);
}
