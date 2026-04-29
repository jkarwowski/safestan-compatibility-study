data {
  int<lower=1> N;             // Number of observations
  array[N] real<lower=0> obs_times; // Observation times
}

parameters {
  real<lower=0> alpha;
  real<lower=0> sigma;
}

model {
  alpha ~ normal(0, 5);
  sigma ~ normal(0, 5);
  obs_times ~ weibull(alpha, sigma);
}
