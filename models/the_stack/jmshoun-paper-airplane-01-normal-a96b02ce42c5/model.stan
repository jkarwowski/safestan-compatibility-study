data {
  int<lower=1> N;
  array[N] int<lower=1, upper=2> method;
  array[N] real<lower=0> distance_;
}
parameters {
  array[2] real<lower=0> mu;
  array[2] real<lower=0> sigma;
}
model {
  distance_ ~ normal(mu[method], sigma[method]);
}
