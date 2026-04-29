data {
  int<lower=0> N;
  vector[N] y;
}
parameters {
  real mu_theta;
  real<lower=0, upper=100> sigma_theta;
  vector[N] theta;
  real<lower=0, upper=100> sigma_y;
}
model {
  mu_theta ~ normal(0, 1);
  sigma_theta ~ uniform(0, 100);
  theta ~ normal(100 * mu_theta, sigma_theta);
  sigma_y ~ uniform(0, 100);
  y ~ normal(theta, sigma_y);
}
generated quantities {
  vector[N] e_theta;
  
  e_theta = theta - mu_theta;
}
