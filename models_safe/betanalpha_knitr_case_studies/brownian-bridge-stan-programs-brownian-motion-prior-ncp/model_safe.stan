data {
  int<lower=1> N;
  array[N] real ts;

  real x_left;
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
}
