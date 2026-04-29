data {
  int<lower=0> N;
  int<lower=0> J;
  array[N] int<lower=1, upper=J> county;
  vector[N] y;
}
parameters {
  vector[J] a;
  real mu_a;
  real<lower=0, upper=100> sigma_a;
  real<lower=0, upper=100> sigma_y;
}
model {
  vector[N] y_hat;

  mu_a ~ normal(0, 1);
  sigma_a ~ uniform(0, 100);
  sigma_y ~ uniform(0, 100);
  a ~ normal(mu_a, sigma_a);

  for (i in 1 : N) {
    y_hat[i] = a[county[i]];
  }

  y ~ normal(y_hat, sigma_y);
}
