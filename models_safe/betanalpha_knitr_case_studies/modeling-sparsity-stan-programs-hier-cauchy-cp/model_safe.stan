data {
  int<lower=0> K;                       // Number of contexts
  int<lower=0> N;                       // Number of observations
  vector[N] y;                          // Observations
  array[N] int<lower=1, upper=K> context_idx; // Context assignments
  real<lower=0> sigma;                  // Measurement variability
}

parameters {
  // Horseshoe parameters
  vector[K] theta;
  real<lower=0> tau;
}

model {
  // Horseshoe prior model
  tau ~ normal(0, 10);
  theta ~ cauchy(0, tau);

  // Observational model
  y ~ normal(theta[context_idx], sigma);
}
