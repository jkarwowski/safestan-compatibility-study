data {
  int<lower=1> N1; // Number of complete observations
  vector[N1] x1;   // Complete observations
  vector[N1] y1;   // Complete observations

  int<lower=1> N2; // Number of incomplete observations
  vector[N2] x2;   // Incomplete observations

  int<lower=1> N_grid; // Number of grid points for quantifying functional behavior
  vector[N_grid] x_grid; // Grid points for quantifying functional behavior
}

parameters {
  real<lower=0> lambda; // Detector calibration, output units / input units
  real<lower=0> psi;    // Detector resolution

  real<lower=0> gamma;  // Detector resolution correction factor (inverse input units)

  // Location and dispersion of completely observed covariate distribution
  // Location has input units, dispersion is unitless
  real<lower=0> mu1;
  real<lower=0> phi1;

  // Location and dispersion of incompletely observed covariate distribution
  // Location has input units, dispersion is unitless
  real<lower=0> mu2;
  real<lower=0> phi2;
}

model {
  lambda ~ normal(0, 0.2);
  psi ~ normal(0, 0.2);

  gamma ~ normal(0, 10);

  mu1 ~ normal(0, 50);
  phi1 ~ normal(0, 5);

  mu2 ~ normal(0, 50);
  phi2 ~ normal(0, 5);

  x1 ~ gamma(inv(phi1) * rep_vector(mu1, N1), inv(phi1));
  y1 ~ gamma(inv(psi + 0.001 * gamma * mu1) * (lambda * x1),
             inv(psi + 0.001 * gamma * mu1));

  x2 ~ gamma(inv(phi2) * rep_vector(mu2, N2), inv(phi2));
}

generated quantities {
  array[N1] real x1_pred; // Complete observation covariate retrodiction
  array[N1] real y1_pred; // Complete observation conditional variate retrodiction
  array[N2] real x2_pred; // Incomplete observation covariate retrodiction
  array[N2] real y2_pred; // Incomplete observation conditional variate prediction

  array[N_grid] real f_grid; // Inferred functional behavior along covariate grid
  array[N_grid] real y2_pred_grid; // Predictive variate behavior along covariate grid

  for (n in 1:N1) {
    x1_pred[n] = gamma_rng(inv(phi1) * mu1, inv(phi1));
    y1_pred[n] = gamma_rng(inv(psi + 0.001 * gamma * mu1) * (lambda * x1[n]),
                           inv(psi + 0.001 * gamma * mu1));
  }

  for (n in 1:N2) {
    x2_pred[n] = gamma_rng(inv(phi2) * mu2, inv(phi2));
    y2_pred[n] = gamma_rng(inv(psi + 0.001 * gamma * mu2) * (lambda * x2[n]),
                           inv(psi + 0.001 * gamma * mu2));
  }

  for (n in 1:N_grid) {
    f_grid[n] = lambda * x_grid[n];
    y2_pred_grid[n] = gamma_rng(inv(psi + 0.001 * gamma * mu2) * f_grid[n],
                                inv(psi + 0.001 * gamma * mu2));
  }
}
