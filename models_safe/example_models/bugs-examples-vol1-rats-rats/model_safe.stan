// http://www.mrc-bsu.cam.ac.uk/bugs/winbugs/Vol1.pdf
// Page 3: Rats
data {
  int<lower=0> N;
  int<lower=0> T;
  array[T] real x;
  array[N, T] real y;
  vector[N * T] y_safestan_flat;
  real xbar;
}
parameters {
  array[N] real alpha;
  array[N] real beta;
  
  real mu_alpha;
  real mu_beta; // beta.c in original bugs model
  
  real<lower=0> sigmasq_y;
  real<lower=0> sigmasq_alpha;
  real<lower=0> sigmasq_beta;
}
transformed parameters {
  real<lower=0> sigma_y; // sigma in original bugs model
  real<lower=0> sigma_alpha;
  real<lower=0> sigma_beta;
  
  sigma_y = sqrt(sigmasq_y);
  sigma_alpha = sqrt(sigmasq_alpha);
  sigma_beta = sqrt(sigmasq_beta);
}
model {
  array[N, T] real y_hat;
  vector[N * T] y_hat_safestan_flat;

  mu_alpha ~ normal(0, 100);
  mu_beta ~ normal(0, 100);
  sigmasq_y ~ inv_gamma(0.001, 0.001);
  sigmasq_alpha ~ inv_gamma(0.001, 0.001);
  sigmasq_beta ~ inv_gamma(0.001, 0.001);
  alpha ~ normal(mu_alpha, sigma_alpha); // vectorized
  beta ~ normal(mu_beta, sigma_beta); // vectorized
  for (n in 1 : N) {
    for (t in 1 : T) {
      y_hat[n, t] = alpha[n] + beta[n] * (x[t] - xbar);
      y_hat_safestan_flat[(n - 1) * T + t] = y_hat[n, t];
    }
  }
  y_safestan_flat ~ normal(y_hat_safestan_flat, sigma_y);
}
generated quantities {
  real alpha0;
  alpha0 = mu_alpha - xbar * mu_beta;
}
