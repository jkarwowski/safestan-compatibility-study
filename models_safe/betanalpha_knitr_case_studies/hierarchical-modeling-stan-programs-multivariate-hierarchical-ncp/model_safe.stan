data {
  int<lower=0> N;      // Number of observations
  int<lower=0> I;      // Number of components
  array[N] vector[I] y;      // Observations
  real<lower=0> sigma; // Measurement variability

  // Number of individuals in hierarchy
  int<lower=0> K;
  // Individual from which each observation is generated
  array[N] int<lower=1, upper=K> indiv_idx;
}

parameters {
  vector[I] mu;              // Population locations
  vector<lower=0>[I] tau;    // Population scales
  cholesky_factor_corr[I] L; // Population correlations
  array[K] vector[I] eta;  // Non-centered individual parameters
}

transformed parameters {
  array[K] vector[I] theta; // Multivariate centered parameters for each individual
  array[N] vector[I] theta_obs; // Multivariate centered parameters for each observation

  for (k in 1:K)
    theta[k] = mu + diag_pre_multiply(tau, L) * eta[k];

  for (n in 1:N)
    theta_obs[n] = theta[indiv_idx[n]];
}

model {
  mu ~ normal(0, 5);        // Prior model
  tau ~ normal(0, 5);       // Prior model
  L ~ lkj_corr_cholesky(4); // Prior model

  // Non-centered hierarchical model
  eta ~ normal(0, 1);

  // Observational model
  y ~ normal(theta_obs, sigma);
}

// Simulate a full observation from the current value of the parameters
generated quantities {
  array[N, I] real y_post_pred;
  for (n in 1:N) {
    y_post_pred[n] = normal_rng(theta_obs[n], sigma);
  }
}
