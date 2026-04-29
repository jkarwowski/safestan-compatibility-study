functions {
  real t_fall(real g, real h) {
    return sqrt(2 * h / g);
  }
}

data {
  int N_heights;
  array[N_heights] real<lower=0> heights;    // meters
  int N_drops;
  array[N_drops * N_heights] real obs_t_fall_flat; // seconds
}

parameters {
  real<lower=0> sigma_t; // seconds
  real g;                // meters per second squared
}

model {
  array[N_drops * N_heights] real mu_t_fall;
  int i;

  // Prior model
  sigma_t ~ normal(0, 1);
  g ~ normal(9.8, 1);

  // Observational model
  i = 1;
  for (n in 1:N_drops) {
    for (h in 1:N_heights) {
      mu_t_fall[i] = t_fall(g, heights[h]);
      i = i + 1;
    }
  }
  obs_t_fall_flat ~ normal(mu_t_fall, sigma_t);
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
