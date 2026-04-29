data {
  int<lower=0> N;
  int<lower=0> D;
  matrix[N, D] X;
  vector[N] y;
}
parameters {
  vector[D] beta;
  real<lower=0> sigma;
}
model {
  // prior
  beta ~ normal(0, 10);
  sigma ~ normal(0, 10);
  // likelihood
  y ~ normal(X * beta, sigma);
}
