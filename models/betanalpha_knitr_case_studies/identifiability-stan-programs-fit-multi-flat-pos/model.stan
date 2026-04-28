data {
  int<lower=1> N;      // Number of observations
  array[N] real y;           // Observations
  real<lower=0> sigma; // Measurement variability
}

parameters {
  real<lower=0> a;
  real b;
}

model {
  // Implicit flat prior model

  // Observational model
  y ~ normal(a * b, sigma);
}
