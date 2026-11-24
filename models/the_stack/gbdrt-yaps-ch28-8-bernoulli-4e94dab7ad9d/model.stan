data {
  int<lower=0> N;
  array[N] int<lower=0, upper=1> y;
  real<lower=0> alpha;
  real<lower=0> beta;
}
parameters {
  real<lower=0, upper=1> theta;
}
model {
  theta ~ beta(alpha, beta);
  for (n in 1:N)
    y[n] ~ bernoulli(theta);
}
