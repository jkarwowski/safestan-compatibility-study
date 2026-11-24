// Basic Model with fixed Resistance per group // base model
//
data {
  int<lower=0> N; // nb of samples
  array[N] real<lower=0> R;    // resistance data
  array[N] int<lower=0> G; // group index
  int<lower=0> N_G;   // number of groups
}


parameters {
  array[N_G] real mu ; // mean per group
  real<lower=0> sigma;  // std dev for all groups
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  // priors
  sigma ~ normal(0, 0.1);
  mu ~ normal(0.5, 0.2);
  // likelihood
  for (i in 1:N)
      R ~ normal(mu[G[i]], sigma);


} // END


