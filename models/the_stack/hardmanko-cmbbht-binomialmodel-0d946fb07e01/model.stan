data {
  int<lower=0> I; // Number of participants
  int<lower=0> J; // Number of conditions

  array[I, J] int<lower=0> trials; // Number of trials
  array[I, J] int<lower=0> success; // Number of successes
  
  int<lower=0> nuc; // Number of unique conditions
  
  // A vector where a 0 means that condition is the cornerstone condition.
  // All matching nonzero values share the same delta parameter value.
  array[J] int deltaEq; 
}
parameters {
	
  array[I] real rho;
  array[nuc] real delta_base; // Does not include the cornerstone condition
  
  real mu_rho;
  real<lower=0.0001> var_rho;
  
}
transformed parameters {
	
  array[J] real delta; // Includes the cornerstone condition
  
  array[I, J] real<lower=0.0001, upper=0.9999> P;
  
  for (j in 1:J) {
    
    // Copy from delta_base to delta, observing the cornerstone condition
    int deltaInd = deltaEq[j];
    if (deltaInd >= 1) {
      delta[j] = delta_base[deltaInd];
    } else {
      delta[j] = 0;
    }
    
    for (i in 1:I) {
      P[i,j] = inv_logit(rho[i] + delta[j]);
    }
  }
}
model {

  mu_rho ~ normal(0, sqrt(2));
  var_rho ~ inv_gamma(2, 2);
  
  // Prior on the non-cornerstone deltas
  for (k in 1:nuc) {
    delta_base[k] ~ cauchy(0, 1);
  }
  
  for (i in 1:I) {
    rho[i] ~ normal(mu_rho, sqrt(var_rho));
    
    for (j in 1:J) {
      success[i,j] ~ binomial(trials[i,j], P[i,j]);
    }
  }
}
