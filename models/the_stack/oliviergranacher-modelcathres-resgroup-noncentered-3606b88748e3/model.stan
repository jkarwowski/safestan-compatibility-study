// Hierarchical Model with fixed Resistance per group // base model
// Non centered
data {
  int<lower=0> N; // nb of samples
  array[N] real<lower=0> R;    // resistance data
  int<lower=0> N_G;   // number of groups
  array[N] int<lower=0, upper= N_G> G; // group index
}


parameters {
  real mu_bar; // overall mean
  array[N_G] real zOffset ; // mean offset in sd per group
  real<lower=0> sigma_bar; // overall std dev
  real<lower=0> sigma;  // std dev for all groups
}
transformed parameters{
  vector[N_G] mu;
  for (j in 1:N_G)
    mu[j] = mu_bar + zOffset[j] * sigma_bar;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  // priors
  mu_bar ~ normal(0.5, 0.1);
  zOffset ~ normal(0, 1);
  sigma ~ exponential(5);
  sigma_bar ~ exponential(10);
  // likelihood
  for (i in 1:N) {
      R ~ normal(mu[G[i]], sigma);
  }

} // END


