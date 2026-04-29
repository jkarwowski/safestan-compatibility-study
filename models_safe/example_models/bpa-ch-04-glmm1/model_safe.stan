data {
  int<lower=0> nobs; // Number of observed data
  int<lower=0> nmis; // Number of missing data
  int<lower=0> nyear; // Number of years
  int<lower=0> nsite; // Number of sites
  array[nobs] int<lower=0> obs; // Observed counts
  array[nmis] int<lower=0> misyear; // Years in missing data
  array[nmis] int<lower=0> missite; // Sites in missing data
}
transformed data {
  array[nobs] int<lower=1> obsyear;
  array[nobs] int<lower=1> obssite;
  array[nyear, nsite] int<lower=0, upper=1> is_missing;
  int pos = 1;

  for (y in 1 : nyear) {
    for (s in 1 : nsite) {
      is_missing[y, s] = 0;
    }
  }
  for (i in 1 : nmis) {
    is_missing[misyear[i], missite[i]] = 1;
  }
  for (y in 1 : nyear) {
    for (s in 1 : nsite) {
      if (is_missing[y, s] == 0) {
        obsyear[pos] = y;
        obssite[pos] = s;
        pos += 1;
      }
    }
  }
}
parameters {
  vector[nsite] alpha; // Random site effects
  real mu_alpha;
  real<lower=0, upper=5> sd_alpha;
}
transformed parameters {
  matrix[nyear, nsite] log_lambda;
  vector[nobs] log_lambda_obs;

  log_lambda = rep_matrix(alpha', nyear);
  for (i in 1 : nobs) {
    log_lambda_obs[i] = log_lambda[obsyear[i], obssite[i]];
  }
}
model {
  // Priors
  mu_alpha ~ normal(0, 10);
  sd_alpha ~ uniform(0, 5);
  alpha ~ normal(mu_alpha, sd_alpha);

  obs ~ poisson_log(log_lambda_obs);
}
generated quantities {
  array[nmis] int<lower=0> mis;

  for (i in 1 : nmis) {
    mis[i] = poisson_log_rng(log_lambda[misyear[i], missite[i]]);
  }
}
