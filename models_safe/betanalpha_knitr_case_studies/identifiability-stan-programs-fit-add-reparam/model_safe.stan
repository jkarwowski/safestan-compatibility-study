data {
  int<lower=1> N;      // Number of observations
  array[N] real y;           // Observations
  real<lower=0> sigma; // Measurement variability
}

parameters {
  real a_plus_b;
}

model {
  // Prior model
  a_plus_b ~ normal(0, 100 * sqrt(2));

  // Observational model
  y ~ normal(a_plus_b, sigma);
}
