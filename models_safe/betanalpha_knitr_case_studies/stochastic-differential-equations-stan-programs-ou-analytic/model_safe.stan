data {
  int<lower=1> N;
  array[N + 1] real t;

  real x0;

  real mu;
  real<lower=0> gamma;
  real<lower=0> tau;
}

transformed data {
  vector[N] x_free_mean;
  matrix[N, N] x_free_chol;

  {
    real prev_mean = x0;

    for (i in 1:N) {
      for (j in 1:N) {
        x_free_chol[i, j] = 0;
      }
    }

    for (n in 1:N) {
      real decay = exp(-gamma * (t[n + 1] - t[n]));
      real sigma = 0.7071 * tau * sqrt((1 - decay) / gamma);

      x_free_mean[n] = mu + (prev_mean - mu) * decay;

      if (n > 1) {
        for (j in 1:(n - 1)) {
          x_free_chol[n, j] = decay * x_free_chol[n - 1, j];
        }
      }
      x_free_chol[n, n] = sigma;

      prev_mean = x_free_mean[n];
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
  x_free ~ multi_normal_cholesky(x_free_mean, x_free_chol);
}
