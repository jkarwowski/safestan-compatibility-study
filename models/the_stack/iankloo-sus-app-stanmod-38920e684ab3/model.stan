
data {
  int<lower=0> N;
  int<lower=0>J; //Number of tests
  vector[N] y;
  array[N] int g; //Group y is in
}
parameters {
  vector[J] mu;
  real<lower=0,upper=30> sigma;
}
model {
  for (n in 1:N) {
    y[n] ~ normal(mu[g[n]], sigma)T[0,100];
  }
  mu ~ normal(70,12);
}
