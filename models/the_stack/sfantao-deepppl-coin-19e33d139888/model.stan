data {
  int N;
  array[N] int<lower=0,upper=1> x;
}
parameters {
  real<lower=0,upper=1> z;
}
model {
  z ~ beta(1, 1);
  for (i in 1:N)
    x[i] ~ bernoulli(z);
}