data {
  int N;
  real mu;
  real<lower=0> sigma;
}

parameters {
  array[N] real y;
}

model {
  y ~ normal(mu, sigma);
}

