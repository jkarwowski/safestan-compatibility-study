data {
  int<lower=1> N;
  array[N] real ts;

  real x_left;
}

parameters {
  array[N - 1] real xs_forward;
}

transformed parameters {
  array[N] real xs = append_array(rep_array(x_left, 1), xs_forward);
}

model {
  for (n in 2:N) {
    xs[n] ~ normal(xs[n - 1], sqrt(ts[n] - ts[n - 1]) );
  }
}
