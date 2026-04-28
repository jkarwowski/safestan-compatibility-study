data {
  int<lower=1> N;
  int<lower=1> T;
  vector[T] time;
  vector[N * T] y_vec;
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

  {
    vector[N * T] mu_y;
    for (n in 1 : N) {
      for (t in 1 : T) {
        mu_y[(n - 1) * T + t] = alpha[n] + beta[n] * time[t];
      }
    }
    y_vec ~ normal(mu_y, sigma_y);
  }
}
