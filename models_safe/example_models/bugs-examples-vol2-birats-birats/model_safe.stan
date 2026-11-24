data {
  int<lower=0> N;
  int<lower=0> T;
  array[T] real x;
  real xbar;
  array[N, T] real y;
  vector[N * T] y_safestan_flat;
  cov_matrix[2] Omega;
}
parameters {
  array[N] vector[2] beta;
  vector[2] mu_beta;
  real<lower=0> sigmasq_y;
  cov_matrix[2] Sigma_beta;
}
transformed parameters {
  real<lower=0> sigma_y;
  sigma_y = sqrt(sigmasq_y);
}
model {
  array[N, T] real eta;
  vector[N * T] eta_safestan_flat;

  sigmasq_y ~ inv_gamma(0.001, 0.001);
  mu_beta ~ normal(0, 100);
  Sigma_beta ~ inv_wishart(2, Omega);
  beta ~ multi_normal(mu_beta, Sigma_beta);

  for (n in 1 : N) {
    for (t in 1 : T) {
      eta[n, t] = beta[n, 1] + beta[n, 2] * x[t];
      eta_safestan_flat[(n - 1) * T + t] = eta[n, t];
    }
  }
  y_safestan_flat ~ normal(eta_safestan_flat, sigma_y);
}
