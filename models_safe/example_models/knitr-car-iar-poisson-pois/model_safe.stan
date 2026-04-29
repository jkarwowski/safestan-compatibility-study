data {
  int<lower=0> N;
  array[N] int<lower=0> y; // count outcomes
  vector<lower=0>[N] E; // exposure
}
transformed data {
  vector[N] log_E = log(E);
}
parameters {
  real beta0; // intercept
}
model {
  beta0 ~ normal(0.0, 2.5);
  y ~ poisson_log(log_E + beta0); // intercept only, no covariates
}
generated quantities {
  vector[N] eta = log_E + beta0;
  vector[N] mu = exp(eta);
}
