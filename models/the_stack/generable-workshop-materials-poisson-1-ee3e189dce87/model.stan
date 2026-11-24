data {
  int N;
  array[N] int x;
}
parameters {
  real<lower=0> lambda;
}
model {
  lambda ~ normal(0, 1);
  x ~ poisson(lambda);
}
generated quantities {
  int x_ppc;
  x_ppc = poisson_rng(lambda);
}
