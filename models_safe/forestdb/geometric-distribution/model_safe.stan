data {
  int<lower=1> N;
  array[N] int<lower=0> y_failures;
}
parameters {
  real<lower=0, upper=1> theta;
}
model {
  theta ~ beta(1, 1);
  y_failures ~ neg_binomial_2((1 - theta) / theta, 1);
}
generated quantities {
  int y_rep = 1 + neg_binomial_2_rng((1 - theta) / theta, 1);
}
