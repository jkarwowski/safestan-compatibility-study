functions {
  real t_fall(real g, real h) {
    return sqrt(2 * h / g);
  }
}

data {
  // Detector calibration data
  int N_calibrations;
  array[N_calibrations] real obs_t_calib;    // seconds

  // Falling data
  int N_heights;
  array[N_heights] real<lower=0> heights;    // meters
  int N_drops;
  array[N_drops, N_heights] real obs_t_fall; // seconds
}

parameters {
  real<lower=0> sigma_t; // seconds
  real g;                // meters per second squared
}

model {
  // Prior model
  sigma_t ~ normal(0, 0.5);
  g ~ inv_gamma(1.49, 2.83);

  // Observational model
  obs_t_calib ~ normal(rep_vector(0, N_calibrations), sigma_t);

  for (n in 1:N_drops) {
    for (h in 1:N_heights) {
      real mu_t_fall = t_fall(g, heights[h]);
      obs_t_fall[n, h] ~ normal(mu_t_fall, sigma_t);
    }
  }
}

// Simulate a full observation from each value of the parameters
generated quantities {
  array[N_drops, N_heights] real obs_t_fall_post_pred;

  for (n in 1:N_drops) {
    for (h in 1:N_heights) {
      real mu_t_fall = t_fall(g, heights[h]);
      obs_t_fall_post_pred[n, h] = normal_rng(mu_t_fall, sigma_t);
    }
  }
}
