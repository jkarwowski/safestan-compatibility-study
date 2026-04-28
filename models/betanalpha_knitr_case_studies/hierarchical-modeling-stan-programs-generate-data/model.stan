data {
  // Number of observations
  int<lower=1> N;

  // Number of individuals in hierarchy
  int<lower=0> K;

  // Individual from which each observation is generated
  array[N] int<lower=1, upper=K> indiv_idx;

  // Measurement variability
  real<lower=0> sigma;
}

transformed data {
  real mu = 4.5;           // Population location
  real<lower=0> tau = 3.5; // Population scale

  // Individual parameters
  array[K] real theta = normal_rng(rep_vector(mu, K), tau);
}

generated quantities {
   // Simulated observations
  array[N] real y = normal_rng(theta[indiv_idx], sigma);
}
