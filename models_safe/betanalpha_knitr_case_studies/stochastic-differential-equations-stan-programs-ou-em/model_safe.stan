data {
  int<lower=1> N;
  array[N + 1] real t;

  real x0;

  real mu;
  real<lower=0> gamma;
  real<lower=0> tau;
}

transformed data {
  vector[N] x_mean;
  matrix[N, N] x_cov;
  array[N] real epsilon;
  array[N] real a;

  for (n in 1:N) {
    epsilon[n] = t[n + 1] - t[n];
    a[n] = 1 - gamma * epsilon[n];

    if (n == 1) {
      x_mean[n] = x0 + gamma * (mu - x0) * epsilon[n];
      x_cov[n, n] = square(tau) * epsilon[n];
    } else {
      x_mean[n] = x_mean[n - 1] + gamma * (mu - x_mean[n - 1]) * epsilon[n];
      for (k in 1:(n - 1)) {
        x_cov[n, k] = a[n] * x_cov[n - 1, k];
        x_cov[k, n] = x_cov[n, k];
      }
      x_cov[n, n] = square(a[n]) * x_cov[n - 1, n - 1] + square(tau) * epsilon[n];
    }
  }
}

parameters {
  vector[N] x_free;
}

transformed parameters {
  array[N + 1] real x;
  x[1] = x0;
  for (n in 1:N) {
    x[n + 1] = x_free[n];
  }
}

model {
  x_free ~ multi_normal(x_mean, x_cov);
}
