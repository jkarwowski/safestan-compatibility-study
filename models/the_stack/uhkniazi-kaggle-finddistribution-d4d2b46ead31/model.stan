data {
    int<lower=1> Ntotal; // number of observations
    array[Ntotal] real y; // response variable - normally distributed
    int<lower=2> iMixtures; // number of mixture distributions
}

parameters { // the parameters to track
    array[iMixtures] real mu; // number of means to track
    array[iMixtures] real<lower=1> sigma; // scale parameters for t distribution  
    array[iMixtures] real<lower=1> nu; // number of normality parameters or degrees of freedom parameters
    simplex[iMixtures] iMixWeights; // weights for the number of mixtures (should sum to one)
  }
// transformed parameters {
//   
// }
model {
  // see stan manual page 187 for an example
  array[iMixtures] real ps; // temporary variable for log components
  // any priors go here 
  
  // loop to calculate likelihood
  for(n in 1:Ntotal){
    // second loop for number of mixture components
    for (k in 1:iMixtures){
      ps[k] = log(iMixWeights[k]) + student_t_lpdf(y[n] | nu[k], mu[k], sigma[k]);
    }
    target += log_sum_exp(ps);
  }
}