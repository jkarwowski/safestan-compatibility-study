data {
  int<lower=1> N;
  array[N] real ts;

  real x_left;

  int<lower=1> N_obs;
  array[N_obs] int<lower=1, upper=N + 1> obs_idx;
  array[N_obs] real x_obs;
  real<lower=0> sigma;
}

parameters {
  array[N - 1] real xs_forward_ncp;
}

transformed parameters {
  array[N] real xs;

  xs[1] = x_left;

  for (n in 2:N) {
    xs[n]
      = xs[n - 1] + sqrt(ts[n] - ts[n - 1]) * xs_forward_ncp[n - 1];
  }
}

model {
  xs_forward_ncp ~ normal(0, 1);
  x_obs ~ normal(xs[obs_idx], sigma);
}
