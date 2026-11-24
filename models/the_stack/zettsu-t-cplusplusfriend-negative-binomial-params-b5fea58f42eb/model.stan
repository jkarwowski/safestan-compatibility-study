data {
  int<lower=0> N;
  array[N] int<lower=0> Y;
}

parameters {
  real<lower=0> alpha;
  real<lower=0> beta;
}

model {
  for(i in 1:N) {
    target += Y[i] * neg_binomial_lpmf(i-1 | alpha, beta);
  }
}
