data {
  int<lower=1> N;
  vector[N] y;
  real mu0;
  real<lower=0> lambda0;
  real<lower=0> alpha0;
  real<lower=0> beta0;
}
parameters {
  real mu;
  real<lower=0> tau;
}
transformed parameters {
  real<lower=0> sigma = inv_sqrt(tau);
}
model {
  tau ~ gamma(alpha0, beta0);
  mu ~ normal(mu0, inv_sqrt(lambda0 * tau));
  y ~ normal(mu, sigma);
}
generated quantities {
  real y_rep = normal_rng(mu, sigma);
}
