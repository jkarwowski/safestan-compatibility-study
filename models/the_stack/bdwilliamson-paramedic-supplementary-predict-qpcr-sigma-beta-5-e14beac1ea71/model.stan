data{
    int<lower=0> N;
    int<lower=0> q_obs;
    int<lower=0> q;
    array[N, q_obs] int<lower=0> V;
    array[N, q] int<lower=0> W;
}
parameters{
    array[N] vector[q] log_mu;
    vector[q] beta;
    row_vector<lower=0>[q] Sigma;
}
transformed parameters{
    array[N] vector<lower=0>[q] mu;
    array[N] vector<lower=0>[q] p;
    mu = exp(log_mu);
    for (j in 1:N){
        p[j] = mu[j]/sum(mu[j]);
    }
}
model {
    beta ~ normal(0, sqrt(5.0));
    Sigma ~ lognormal(0, sqrt(5.0));
    
    for (j in 1:N){
        log_mu[j] ~ normal(beta, Sigma);
        V[j] ~ poisson(mu[j,1:q_obs]);
        W[j] ~ multinomial(p[j]);
    }
}

