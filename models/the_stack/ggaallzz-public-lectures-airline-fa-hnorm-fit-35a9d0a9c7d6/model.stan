data {
  int M;//number of years analyzed
  array[M] int y;//number of fatal accidents
}
parameters {
  real<lower=0>lambda;
}
model {
  lambda ~ normal(0,121);
  for (k in 1:M) {
    y[k] ~ poisson(lambda);
  }
}
generated quantities {
  array[M] int y_sim;
  for (k in 1:M) {
    y_sim[k] = poisson_rng(lambda);
  }
}
