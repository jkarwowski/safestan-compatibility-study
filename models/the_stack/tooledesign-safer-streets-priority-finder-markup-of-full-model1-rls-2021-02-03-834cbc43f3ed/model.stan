//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N; // the # of census tracts
  array[N] real<lower = 0> alpha_B; // alpha_B_k, alpha_B_a, alpha_B_b etc. to run this all at once 
  array[N] real<lower = 0> beta_B;
  array[N] real<lower = 0> alpha_G;
  array[N] real<lower = 0> beta_G;

}

// can convert from wide to long before feeding it into here
// build a long dataset with a pkey where each row represents severity*seg (with the tract agg thing done)
// n=pkey
// can group by alpha_B, beta_B, alpha_G, beta_G and run only once for each unique combo of these. 
// join on unique combo of those four things, or an ID representing that grouping. 


// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.

parameters {
  array[N] real<lower = 0, upper = 1> phi;
  array[N] real<lower = 0> lambda;
}



// would expand phi_k, etc., for all of the below. final output matrix will be (n segs * n severity) cols with rows based on n trials still
  
// The model to be estimated. We model the output
// 'theta' using a beta distributions with parameters alpha and beta..this is merely to 
// test the beta distribution--expect garbage results.
model {
    phi ~ beta (alpha_B, beta_B); // phi is our beta dist, with params alpha/beta. ranges 0-1
    lambda ~ gamma (alpha_G, beta_G); // lambda is gamma dist, with params alpha/beta. ranges 0-???? lambda akin to poisson param lambda.
 }
 // theta = total n of instances of crashes in that tract, that we are next allocating to segments. 
 // lambda is the input to the poisson dist that defines theta (see below)

generated quantities{
  array[N] int<lower = 0> theta = poisson_rng(lambda);
  array[N] int crashes = binomial_rng(theta, phi); //this is our final outcome, crashes per segment
}
 
