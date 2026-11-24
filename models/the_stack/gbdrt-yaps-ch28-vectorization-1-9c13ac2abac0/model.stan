data {
  int<lower=1> K;
  int<lower=1> N;
  array[K, N] real x;
  array[N] real y;
}
parameters {
  array[K] real beta;
}
model {
  for (n in 1:N) {
    real gamma = 0;
    for (k in 1:K)
      gamma += x[n, k] * beta[k];
    y[n] ~ normal(gamma, 1);
  }
}
