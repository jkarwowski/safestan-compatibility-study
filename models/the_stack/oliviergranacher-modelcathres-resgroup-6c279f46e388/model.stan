// Hierarchical Model with fixed Resistance per group // base model
// 480s for 1000 iterations !!!
data {
  int<lower=0> N; // nb of samples
  array[N] real<lower=0> R;    // resistance data
  array[N] int<lower=0> G; // group index
  int<lower=0> N_G;   // number of groups
}


parameters {
  real mu_bar; // overall mean
  real sigma_bar; // overall std dev
  array[N_G] real mu ; // mean per group
  real sigma;  // std dev for all groups
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  // priors
  mu ~ normal(mu_bar, sigma_bar);
  sigma ~ exponential(5);
  mu_bar ~ normal(0.5, 0.1);
  sigma_bar ~ exponential(5);
  // likelihood
  for (i in 1:N) {
      R ~ normal(mu[G[i]], sigma);
  }

} // END


