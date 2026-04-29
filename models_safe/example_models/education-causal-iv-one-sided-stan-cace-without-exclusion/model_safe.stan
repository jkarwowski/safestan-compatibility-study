data {
  int<lower=0> N_z1;
  array[N_z1] int<lower=0, upper=1> W_z1;

  int<lower=0> N_z1_w1;
  array[N_z1_w1] int<lower=0, upper=1> Y_z1_w1;

  int<lower=0> N_z1_w0;
  array[N_z1_w0] int<lower=0, upper=1> Y_z1_w0;

  int<lower=0> N_z0_w0;
  array[N_z0_w0] int<lower=0, upper=1> Y_z0_w0;
}

parameters {
  // Population probability of being a complier
  real<lower=0, upper=1> pi_c;
  
  // Probabilities for the binomial outcome distributions
  real<lower=0, upper=1> eta_c0;
  real<lower=0, upper=1> eta_c1;
  real<lower=0, upper=1> eta_n0;
  real<lower=0, upper=1> eta_n1;
} 

model {
  // Prior for Complier probability
  pi_c ~ uniform(0, 1);
  
  // Priors for outcome model parameters
  eta_c0 ~ beta(2, 2);  
  eta_c1 ~ beta(2, 2);  
  eta_n0 ~ beta(2, 2);
  eta_n1 ~ beta(2, 2);

  // Likelihood
  W_z1 ~ bernoulli(pi_c);
  Y_z1_w1 ~ bernoulli(eta_c1);
  Y_z1_w0 ~ bernoulli(eta_n1);
  Y_z0_w0 ~ bernoulli(pi_c * eta_c0 + (1 - pi_c) * eta_n0);
}

generated quantities {
  // Super-population average causal effects 
  real CACE = (eta_c1 - eta_c0) * 10^3;
  real NACE = (eta_n1 - eta_n0) * 10^3;
}
