data {
  int<lower=1> N;
  array[N] int<lower=1> x;
  array[N] int<lower=0, upper=N> y;
}

parameters {
  real beta0;
  real beta1;
}

model {
  for(i in 1:N)
    y[i] ~ binomial(N, inv_logit(beta0 + beta1 * x[i]));
}
