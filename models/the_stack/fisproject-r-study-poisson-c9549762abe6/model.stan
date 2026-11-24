data {
  int<lower=1> N;
  array[N] int<lower=1> x;
  array[N] int<lower=1> y;
}

parameters {
  real beta0;
  real beta1;
}

model {
  for(i in 1:N)
    y[i] ~ poisson_log(beta0 + beta1 * x[i]);
}
