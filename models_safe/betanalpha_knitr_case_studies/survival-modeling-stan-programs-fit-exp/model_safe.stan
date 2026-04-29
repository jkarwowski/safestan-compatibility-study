data {
  int<lower=1> N;             // Number of observations
  array[N] real<lower=0> obs_times; // Observation times
}

parameters {
  real<lower=0> gamma;
}

model {
  gamma ~ normal(0, 5);
  obs_times ~ exponential(gamma);
}
