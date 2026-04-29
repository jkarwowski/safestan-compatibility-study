functions {
  // Location-dispersion paramaeterization of gamma family
  real gamma_ld_rng(real mu, real phi) {
    real beta = inv(phi);
    real alpha = beta * mu;
    return gamma_rng(alpha, beta);
  }
}

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
}

model {
  lambda ~ normal(0, 0.2);
  psi ~ normal(0, 0.2);

  {
    real beta = inv(psi);
    vector[N1] alpha = beta * (lambda * x1);
    y1 ~ gamma(alpha, beta);
  }
}

generated quantities {
  array[N1] real y1_pred; // Complete observation conditional variate retrodiction
  array[N2] real y2_pred; // Incomplete observation conditional variate prediction

  array[N_grid] real f_grid;       // Inferred functional behavior along covariate grid
  array[N_grid] real y2_pred_grid; // Predictive variate behavior along covariate grid

  for (n in 1:N1) {
    y1_pred[n] = gamma_ld_rng(lambda * x1[n], psi);
  }

  for (n in 1:N2) {
    y2_pred[n] = gamma_ld_rng(lambda * x2[n], psi);
  }

  for (n in 1:N_grid) {
    f_grid[n] = lambda * x_grid[n];
    y2_pred_grid[n] = gamma_ld_rng(f_grid[n], psi);
  }
}
