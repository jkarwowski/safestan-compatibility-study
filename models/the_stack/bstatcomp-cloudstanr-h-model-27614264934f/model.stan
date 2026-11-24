data {
  int<lower=1> n;
  int<lower=1> m;
  matrix[m,n] y;
}

parameters {
  real mu0;
  real<lower=0> sigma0;

  array[m] real mu;
  array[m] real sigma;
}

model {
  mu ~ normal(mu0, sigma0);

  for (i in 1:m) {
    y[m] ~ normal(mu[i], sigma[i]);
  }
}
