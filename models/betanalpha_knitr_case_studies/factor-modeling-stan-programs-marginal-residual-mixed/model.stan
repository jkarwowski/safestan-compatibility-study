data {
  int<lower=0> N;      // Number of observations
  vector[N] y;         // Observations
  real<lower=0> sigma; // Measurement variability

  // Factor information
  int<lower=0> N_factor_levels;
  array[N] int<lower=1, upper=N_factor_levels> obs_to_level;

  int<lower=0, upper=N_factor_levels> L_ncp;                 // Number of noncentered levels
  array[L_ncp] int<lower=1, upper=N_factor_levels> factor_ncp_idx; // Index of noncentered levels

  int<lower=0, upper=N_factor_levels> L_cp;                  // Number of centered levels
  array[L_cp] int<lower=1, upper=N_factor_levels> factor_cp_idx;   // Index of noncentered levels
}

parameters {
  // Hierarchical model for between-level residuals
  vector[L_ncp] delta_factor_ncp; // Non-centered residuals
  vector[L_cp]  delta_factor_cp;  // Centered residuals
  real<lower=0> delta_factor_tau; // Residual scale

  // Baseline
  real baseline;
}

transformed parameters {
  vector[N_factor_levels] delta_factor;
  vector[N_factor_levels] theta_level;

  delta_factor[factor_ncp_idx] = delta_factor_tau * delta_factor_ncp;
  delta_factor[factor_cp_idx] = delta_factor_cp;

  theta_level =  baseline      // Baseline
               + delta_factor; // Between-level variation
}

model {
  delta_factor_cp ~ normal(0, delta_factor_tau);
  delta_factor_ncp ~ normal(0, 1);
  delta_factor_tau ~ normal(0, 3);

  baseline ~ normal(0, 5);

  y ~ normal(theta_level[obs_to_level], sigma);
}
