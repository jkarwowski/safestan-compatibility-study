data {
  int<lower=0> nobs; // Number of observed data
  int<lower=0> nmis; // Number of missing data
  int<lower=0> nyear; // Number of years
  int<lower=0> nsite; // Number of sites
  array[nobs] int<lower=0> obs; // Observed counts
  array[nobs] int<lower=0> obsyear; // Years in observed data
  array[nobs] int<lower=0> obssite; // Sites in observed data
  array[nmis] int<lower=0> misyear; // Years in missing data
  array[nmis] int<lower=0> missite; // Sites in missing data
}
parameters {
  real mu; // Grand mean
  vector[nsite] alpha; // Random site effects
  real<lower=0, upper=5> sd_alpha;
  vector[nyear] eps; // Random year effects
  real<lower=0, upper=3> sd_eps;
}
transformed parameters {
  matrix[nyear, nsite] log_lambda;
  
  log_lambda = mu + rep_matrix(alpha', nyear) + rep_matrix(eps, nsite);
}
model {
  vector[nobs] log_lambda_obs;

  // Priors
  mu ~ normal(0, 10);
  sd_alpha ~ uniform(0, 5);
  alpha ~ normal(0, sd_alpha);
  sd_eps ~ uniform(0, 3);
  eps ~ normal(0, sd_eps);
  
  // Likelihood
  for (i in 1 : nobs) {
    log_lambda_obs[i] = log_lambda[obsyear[i], obssite[i]];
  }
  obs ~ poisson_log(log_lambda_obs);
}
generated quantities {
  array[nmis] int<lower=0> mis;
  
  for (i in 1 : nmis) {
    mis[i] = poisson_log_rng(log_lambda[misyear[i], missite[i]]);
  }
}
