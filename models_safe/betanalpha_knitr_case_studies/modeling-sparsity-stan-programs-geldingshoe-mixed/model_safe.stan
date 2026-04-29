data {
  int<lower=0> K;                       // Number of groups
  int<lower=0> N;                       // Number of observations
  vector[N] y;                          // Observations
  array[N] int<lower=1, upper=K> context_idx; // Context assignments

  int<lower=0, upper=K> K_cp;
  array[K_cp] int<lower=0, upper=K> cp_idx;

  int<lower=0, upper=K> K_ncp;
  array[K_ncp] int<lower=0, upper=K> ncp_idx;

  real<lower=0> tau;                    // Base Population Scale
  real<lower=0> sigma;                  // Measurement variability
}

parameters {
  vector[K_cp] theta_cp;
  vector[K_ncp] theta_ncp;

  vector<lower=0>[K] lambda;
}

transformed parameters {
  vector[K] theta;
  theta[cp_idx] = theta_cp;
  theta[ncp_idx] = theta_ncp .* lambda[ncp_idx];
}

model {
  // Horseshoe prior model
  lambda ~ cauchy(0, 1);
  theta_cp ~ normal(0, lambda[cp_idx] * tau);
  theta_ncp ~ normal(0, tau);

  // Observational model
  y ~ normal(theta[context_idx], sigma);
}
