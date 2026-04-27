data {
  int<lower=1> N;
  array[N] int<lower=1> y;
}
transformed data {
  array[N] int<lower=0> y_failures;
  for (n in 1 : N) {
    y_failures[n] = y[n] - 1;
  }
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
