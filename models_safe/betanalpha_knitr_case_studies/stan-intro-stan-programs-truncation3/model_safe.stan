transformed data {
  real a = 0.25; // Known truncation
}

parameters {
  real<lower=a> x; // Constrained parameter
}

model {
  x ~ normal(0, 1);  // Nominal target density
}
