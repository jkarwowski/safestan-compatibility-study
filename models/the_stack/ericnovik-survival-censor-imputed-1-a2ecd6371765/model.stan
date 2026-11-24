data {
  int<lower = 0> N_obs;
  int<lower = 0> N_cens;
  array[N_obs] real y_obs;
}
parameters {
  real<lower = max(y_obs)> U;
  array[N_cens] real<lower = U> y_cens;
  real mu;
  real<lower = 0> sigma;
} 
model {
  mu ~ normal(0, 5);
  sigma ~ normal(0, 5);
  U ~ normal(0, 3);
  y_obs ~ normal(mu, sigma);
  y_cens ~ normal(mu, sigma);
}
