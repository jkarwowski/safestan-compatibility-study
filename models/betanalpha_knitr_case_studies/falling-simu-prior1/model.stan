functions {
  real t_fall(real g, real h) {
    return sqrt(2 * h / g);
  }
}

data {
  int N_heights;
  array[N_heights] real<lower=0> heights; // meters
  int N_drops;
}

generated quantities {
  real<lower=0> sigma_t = abs(normal_rng(0, 0.5));
  real<lower=0> g = inv_gamma_rng(1.49, 2.83);

  array[N_drops, N_heights] real mu_t_fall;
  array[N_drops, N_heights] real obs_t_fall;

  for (n in 1:N_drops) {
    for (h in 1:N_heights) {
      mu_t_fall[n, h] = t_fall(g, heights[h]);
      obs_t_fall[n, h] = normal_rng(mu_t_fall[n, h], sigma_t);
    }
  }
}
