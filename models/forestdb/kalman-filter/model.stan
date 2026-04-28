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
  x[1] ~ normal(0, 2);
  for (t in 2:T) {
    x[t] ~ normal(phi * x[t - 1], sigma_state);
  }
  y ~ normal(x, sigma_obs);
}
generated quantities {
  vector[T] y_rep;
  for (t in 1:T) {
    y_rep[t] = normal_rng(x[t], sigma_obs);
  }
}
