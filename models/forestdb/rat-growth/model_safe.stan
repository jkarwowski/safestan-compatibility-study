data {
  int<lower=1> N;
  int<lower=1> T;
  vector[T] time;
  vector[N * T] y;
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
model {
  vector[N] alpha;
  vector[N] beta;
  vector[N * T] mu_y;

  mu_alpha ~ normal(50, 20);
  mu_beta ~ normal(7, 5);
  sigma_alpha ~ normal(0, 10);
  sigma_beta ~ normal(0, 5);
  sigma_y ~ normal(0, 5);
  alpha_raw ~ normal(0, 1);
  beta_raw ~ normal(0, 1);

  alpha = mu_alpha + sigma_alpha * alpha_raw;
  beta = mu_beta + sigma_beta * beta_raw;
  for (n in 1:N) {
    for (t in 1:T) {
      mu_y[(n - 1) * T + t] = alpha[n] + beta[n] * time[t];
    }
  }
  y ~ normal(mu_y, sigma_y);
}
