// ARMA(1,1) with Wayne Folta-style err encoding
// SafeStan-compatible equivalent using a single multivariate-normal observation

data {
  int<lower=1> T; // number of observations
  vector[T] y; // observed outputs
}
parameters {
  real mu; // mean term
  real phi; // autoregression coeff
  real theta; // moving avg coeff
  real<lower=0> sigma; // noise scale
}
model {
  vector[T] y_mean;
  matrix[T, T] L;

  mu ~ normal(0, 10);
  phi ~ normal(0, 2);
  theta ~ normal(0, 2);
  sigma ~ cauchy(0, 5);

  y_mean[1] = mu - phi * mu;
  L = rep_matrix(0, T, T);
  L[1, 1] = 1;

  if (T > 1) {
    for (t in 2 : T) {
      y_mean[t] = mu + phi * y_mean[t - 1];
      for (j in 1 : (t - 1)) {
        L[t, j] = phi * L[t - 1, j];
      }
      L[t, t - 1] = L[t, t - 1] + theta;
      L[t, t] = 1;
    }
  }

  y ~ multi_normal_cholesky(y_mean, sigma * L);
}
