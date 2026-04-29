// ForestDB translation: Kalman Filter
data {
  int<lower=1> T;
  vector[T] y;
}
parameters {
  real<lower=-1, upper=1> phi;
  real<lower=0> sigma_state;
  real<lower=0> sigma_obs;
  vector[T] x;
}
model {
  phi ~ normal(0.8, 0.3);
  sigma_state ~ lognormal(-1, 0.5);
  sigma_obs ~ lognormal(-1, 0.5);

  {
    vector[T] zero;
    matrix[T, T] Sigma;
    zero = rep_vector(0, T);
    Sigma[1, 1] = 4;
    if (T > 1) {
      for (t in 2:T) {
        for (j in 1:(t - 1)) {
          Sigma[t, j] = phi * Sigma[t - 1, j];
          Sigma[j, t] = Sigma[t, j];
        }
        Sigma[t, t] = square(phi) * Sigma[t - 1, t - 1] + square(sigma_state);
      }
    }
    x ~ multi_normal(zero, Sigma);
  }

  y ~ normal(x, sigma_obs);
}
generated quantities {
  vector[T] y_rep;
  for (t in 1:T) {
    y_rep[t] = normal_rng(x[t], sigma_obs);
  }
}
