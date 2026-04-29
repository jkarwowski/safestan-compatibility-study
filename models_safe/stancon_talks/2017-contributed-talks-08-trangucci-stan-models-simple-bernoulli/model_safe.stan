data {
  int<lower=1> N;
  array[N] int<lower=0,upper=1> y;
}
parameters {
  real<lower=0,upper=1> theta;
}
model {
  theta ~ beta(4,4);
  y ~ bernoulli(theta);
}
