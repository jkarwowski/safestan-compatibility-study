data {
  int<lower = 0> N;
  array[N] int<lower = 0> trial;
  array[N] int<lower = 0> success;
}
parameters {
  real<lower = 0> alpha0;
  real<lower = 0> beta0;
}
model {
  success ~ beta_binomial(trial, alpha0, beta0);
}
