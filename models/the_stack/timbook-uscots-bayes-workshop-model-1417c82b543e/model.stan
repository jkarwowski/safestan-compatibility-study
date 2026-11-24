data {
  int<lower=0> J;
  array[J] int eggs;
}

parameters {
  real<lower=0, upper=1> p;
}

model {
  // Priors
  p ~ beta(2, 10);
  
  // Likelihood
  eggs ~ binomial(12, p);
}