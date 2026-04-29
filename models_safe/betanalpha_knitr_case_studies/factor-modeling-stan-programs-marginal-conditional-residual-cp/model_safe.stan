data {
  int<lower=0> N;      // Number of observations
  vector[N] y;         // Observations

  real<lower=0> sigma; // Measurement variability

  // Number of individual contexts
  int<lower=0> K;
  array[N] int<lower=1, upper=K> obs_to_context;

  // Factor information
  int<lower=0> N_factor_levels;
  array[K] int<lower=1, upper=N_factor_levels> context_to_level;
}

parameters {
  // Centered hierarchical models for the within-level residuals
  vector[K] delta_context;                          // Centered residuals
  array[N_factor_levels] real<lower=0> delta_context_tau; // Residual population scales

  // Centered hierarchical model for between level residuals
  vector[N_factor_levels] delta_factor; // Centered residuals
  real<lower=0> delta_factor_tau;       // Residual population scales

  // Baseline
  real baseline;
}

transformed parameters {
  vector[K] theta_context =  baseline                        // Baseline
                           + delta_factor[context_to_level]  // Between level variation
                           + delta_context;                  // Within level variation
}

model {
  delta_context_tau ~ normal(0, 3);
  delta_factor_tau ~ normal(0, 3);

  delta_context ~ normal(0, delta_context_tau[context_to_level]);
  delta_factor ~ normal(0, delta_factor_tau);

  baseline ~ normal(0, 5);

  y ~ normal(theta_context[obs_to_context], sigma);
}
