data {
  int N;
  array[N] int y;
}
parameters {
  real<lower=0, upper=1> beta;
}
model {
  beta ~ uniform(0, 1);
  for (i in 1:N) {
    y[i] ~ bernoulli(beta);
  }
}
