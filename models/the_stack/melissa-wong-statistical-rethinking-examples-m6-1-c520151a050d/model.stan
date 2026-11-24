//
// Simple binary logistic model for HW problem 6 part 1a

// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N;
  int<lower=0> Ngender;
  array[N] int gender;
  array[N] int awards;
  array[N] int applications;
}

// The parameters accepted by the model. 
parameters {
  array[Ngender] real alpha;
}

// The model to be estimated. 
model {
  // Likelihood
  //target += binomial_logit_lpmf(awards | applications, alpha[gender]);
  awards ~ binomial_logit(applications, alpha[gender]);
  
  // Prior
  //target += normal_lpdf(alpha[gender] | 0, 1);
  alpha[gender] ~ normal(0, 1);
}

generated quantities {
  // Posterior Predictive
  array[N] int awards_pred;
  awards_pred = binomial_rng(applications,
    inv_logit(alpha[gender]));
}
