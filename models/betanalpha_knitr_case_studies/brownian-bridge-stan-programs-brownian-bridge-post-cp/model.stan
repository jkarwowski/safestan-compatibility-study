functions {
  real bridge_lpdf(real x, real t, real t_left, real x_left, real t_right, real x_right) {
    real mu = x_left + (t - t_left) / (t_right - t_left) * (x_right - x_left);
    real sigma2 = (t_right - t) * (t - t_left) / (t_right - t_left);
    return normal_lpdf(x | mu, sqrt(sigma2));
  }

  real bridge_rng(real t, real t_left, real x_left, real t_right, real x_right) {
    real mu = x_left + (t - t_left) / (t_right - t_left) * (x_right - x_left);
    real sigma2 = (t_right - t) * (t - t_left) / (t_right - t_left);
    return normal_rng(mu, sqrt(sigma2));
  }
}

data {
  int<lower=1> N;
  array[N] real ts;

  real x_left;
  real x_right;

  array[N - 2] int left_idxs;
  array[N - 2] int center_idxs;
  array[N - 2] int right_idxs;

  int<lower=1> N_obs;
  array[N_obs] int obs_idxs;
  array[N_obs] real x_obs;
  real<lower=0> sigma;
}

parameters {
  array[N - 2] real interior_xs;
  //real<lower=0> sigma;
}

transformed parameters {
  array[N] real xs;
  xs[1] = x_left;
  xs[2:(N - 1)] = interior_xs;
  xs[N] = x_right;
}

model {
  for (n in 1:(N - 2)) {
    target += bridge_lpdf(xs[center_idxs[n]] | ts[center_idxs[n]],
                                               ts[left_idxs[n]],  xs[left_idxs[n]],
                                               ts[right_idxs[n]], xs[right_idxs[n]]);
  }
  //sigma ~ normal(0, 0.1);

  x_obs ~ normal(xs[obs_idxs], sigma);
}
