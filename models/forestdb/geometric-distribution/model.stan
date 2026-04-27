data {
  int<lower=1> N;
  array[N] int<lower=1> y;
}
parameters {
  real<lower=0, upper=1> theta;
}
model {
  theta ~ beta(1, 1);
  for (n in 1 : N) {
    target += geometric_lpmf(y[n] - 1 | theta);
  }
}
generated quantities {
  int y_rep = 1 + geometric_rng(theta);
}
