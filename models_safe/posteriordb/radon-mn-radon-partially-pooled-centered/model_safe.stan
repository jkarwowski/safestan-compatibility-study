data {
  int<lower=0> N;
  int<lower=0> J;
  array[N] int<lower=1, upper=J> county_idx;
  vector[N] log_radon;
}
parameters {
  vector[J] alpha;
  real mu_alpha;
  real<lower=0> sigma_alpha;
  real<lower=0> sigma_y;
}
model {
  vector[N] mu;
  
  // priors
  sigma_y ~ normal(0, 1);
  sigma_alpha ~ normal(0, 1);
  mu_alpha ~ normal(0, 10);
  alpha ~ normal(mu_alpha, sigma_alpha);
  
  // deterministic linear predictor
  for (n in 1 : N) {
    mu[n] = alpha[county_idx[n]];
  }
  
  // likelihood
  log_radon ~ normal(mu, sigma_y);
}
