data {
  int<lower=1> N;
  array[N] real ts;

  real x_left;
}

transformed data {
  vector[N - 1] xs_forward_mean = rep_vector(x_left, N - 1);
  matrix[N - 1, N - 1] xs_forward_chol;

  for (i in 1:(N - 1)) {
    for (j in 1:(N - 1)) {
      if (j <= i) {
        xs_forward_chol[i, j] = sqrt(ts[j + 1] - ts[j]);
      } else {
        xs_forward_chol[i, j] = 0;
      }
    }
  }
}

parameters {
  vector[N - 1] xs_forward;
}

transformed parameters {
  array[N] real xs;

  xs[1] = x_left;
  for (n in 2:N) {
    xs[n] = xs_forward[n - 1];
  }
}

model {
  xs_forward ~ multi_normal_cholesky(xs_forward_mean, xs_forward_chol);
}
