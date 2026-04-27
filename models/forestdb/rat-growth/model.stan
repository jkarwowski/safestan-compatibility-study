data {
  int<lower=1> N;
  int<lower=1> T;
  vector[T] time;
  matrix[N, T] y;
}
parameters {
  real mu_alpha;
  real mu_beta;
  real<lower=0> sigma_alpha;
  real<lower=0> sigma_beta;
  real<lower=0> sigma_y;
  vector[N] alpha_raw;
  vector[N] beta_raw;
}
transformed parameters {
  vector[N] alpha = mu_alpha + sigma_alpha * alpha_raw;
  vector[N] beta = mu_beta + sigma_beta * beta_raw;
}
model {
  mu_alpha ~ normal(50, 20);
  mu_beta ~ normal(7, 5);
  sigma_alpha ~ normal(0, 10);
  sigma_beta ~ normal(0, 5);
  sigma_y ~ normal(0, 5);
  alpha_raw ~ normal(0, 1);
  beta_raw ~ normal(0, 1);
  for (n in 1 : N) {
    for (t in 1 : T) {
      y[n, t] ~ normal(alpha[n] + beta[n] * time[t], sigma_y);
    }
  }
}
