data {
  int N;    // Number of observations
  array[N] int y; // Count at each observation
}

parameters {
  real<lower=0> lambda; // Poisson intensity
}

model {
  lambda ~ normal(0, 6); // Prior model
  y ~ poisson(lambda);         // Observational model
}
