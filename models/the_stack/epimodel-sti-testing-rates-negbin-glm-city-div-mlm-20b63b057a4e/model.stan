data {
  int<lower=1> N;                 // rows of data
  int<lower=1> J;                 // unique cities
  int<lower=1> D;                 // unique divisions
  array[N] int<lower=1,upper=J> city;   // city predictor
  array[N] int<lower=1,upper=D> div;    // division predictor
  array[N] int<lower=0> y;              // response
}
parameters {
  vector[J] a;              // city intercepts
  real mu_a;
  real<lower=0> sigma_a;
  vector[D] b;
  real mu_b;
  real<lower=0> sigma_b;
  real<lower=0> phi_y;     // dispersion parameter
}
model {
  vector[N] y_hat;
  for (i in 1:N) {
    y_hat[i] = a[city[i]] + b[div[i]];
  }

  mu_a ~ cauchy(0.75, 5);
  sigma_a ~ normal(0.18, 0.1);
  a ~ normal(1, 5);

  mu_b ~ cauchy(0.75, 5);
  sigma_b ~ normal(0.18, 0.1);
  b ~ normal(1, 5);

  phi_y ~ cauchy(1, 3);

  a ~ normal(mu_a, sigma_a);
  b ~ normal(mu_b, sigma_b);
  y ~ neg_binomial_2_log(y_hat, phi_y);
}
