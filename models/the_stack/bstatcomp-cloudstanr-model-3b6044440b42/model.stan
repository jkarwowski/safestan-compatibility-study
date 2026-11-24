data {
  int<lower=1> n; // number of values
  array[n] real y; // values
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  y ~ normal(mu, sigma);
}
