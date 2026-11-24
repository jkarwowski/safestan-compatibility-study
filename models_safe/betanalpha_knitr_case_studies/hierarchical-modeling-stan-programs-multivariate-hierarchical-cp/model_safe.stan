data {
  int<lower=0> N;      // Number of observations
  int<lower=0> I;      // Number of components
  vector[N * I] y;      // Observations, flattened by observation then component
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
  array[K] vector[I] theta;        // Centered individual parameters
}

model {
  vector[N * I] theta_obs;

  mu ~ normal(0, 5);        // Prior model
  tau ~ normal(0, 5);       // Prior model
  L ~ lkj_corr_cholesky(4); // Prior model

  // Centered hierarchical model
  theta ~ multi_normal_cholesky(mu, diag_pre_multiply(tau, L));

  // Observational model
  for (n in 1:N) {
    for (i in 1:I) {
      theta_obs[(n - 1) * I + i] = theta[indiv_idx[n]][i];
    }
  }
  y ~ normal(theta_obs, sigma);
}

// Simulate a full observation from the current value of the parameters
generated quantities {
  array[N] vector[I] y_post_pred;
  for (n in 1:N)
    y_post_pred[n] = to_vector(normal_rng(theta[indiv_idx[n]], sigma));
}
