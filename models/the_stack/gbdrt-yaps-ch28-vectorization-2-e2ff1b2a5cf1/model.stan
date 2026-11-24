data {
  int<lower=1> K;
  int<lower=1> N;
  array[N] vector[K] x;
  array[N] real y;
}
parameters {
  vector[K] beta;
}
model {
  for (n in 1:N)
    y[n] ~ normal(dot_product(x[n], beta), 1);
}
