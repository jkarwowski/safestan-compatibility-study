data {
  int N;
  array[N] int<lower=0> y;
  real a;
  real b;
}
parameters {
  real<lower=0> theta;
}
model {
  theta ~ gamma(a,b);
  for (n in 1:N) {
    y[n] ~ poisson(theta);
  }
}
