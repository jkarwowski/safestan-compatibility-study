parameters {
  real x;
  real<lower=0> tau;
}

model {
  tau ~ normal(0, 3);
  x ~ normal(0, tau);
}
