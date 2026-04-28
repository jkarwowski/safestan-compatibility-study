data {
  int<lower=1> N;      // Number of observations
  array[N] real y;           // Observations
  real<lower=0> sigma; // Measurement variability
}

parameters {
  real a;
  real b;
}

model {
  // Prior model
  a ~ normal(0, 100);

  // Observational model
  y ~ normal(a + b, sigma);
}
