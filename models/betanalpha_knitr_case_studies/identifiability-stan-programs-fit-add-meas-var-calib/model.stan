data {
  int<lower=1> N;  // Number of observations
  array[N] real y;       // Observations

  int<lower=1> N_calib;  // Number of calibration observations
  array[N_calib] real y_calib; // Calibration observations
}

parameters {
  real a;
  real b;
  real<lower=0> sigma;
}

model {
  // Prior model
  a ~ normal(0, 1);
  b ~ normal(0, 1);
  sigma ~ normal(0, 1);

  // Calibration observational model
  y_calib ~ normal(0, sigma);

  // Observational model
  y ~ normal(a + b, sigma);
}
