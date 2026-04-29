data {
  int<lower=1> N;
  array[N] real ts;

  real x_left;
  real x_right;

  array[N - 2] int left_idxs;
  array[N - 2] int center_idxs;
  array[N - 2] int right_idxs;

  int<lower=1> N_obs;
  array[N_obs] int obs_idx;
  array[N_obs] real x_obs;
  real<lower=0> sigma;
}

parameters {
  array[N - 2] real xs_interior_ncp;
}

transformed parameters {
  array[N] real xs;

  xs[1] = x_left;
  xs[N] = x_right;

  for (n in 1:(N - 2)) {
    real t = ts[center_idxs[n]];
    real t_l = ts[left_idxs[n]];
    real x_l = xs[left_idxs[n]];
    real t_r = ts[right_idxs[n]];
    real x_r =  xs[right_idxs[n]];

    real mu = x_l + (t - t_l) / (t_r - t_l) * (x_r - x_l);
    real sigma2 = (t_r - t) * (t - t_l) / (t_r - t_l);

    xs[center_idxs[n]] = mu + sqrt(sigma2) * xs_interior_ncp[n];
  }
}

model {
  xs_interior_ncp ~ normal(0, 1);
  x_obs ~ normal(xs[obs_idx], sigma);
}
