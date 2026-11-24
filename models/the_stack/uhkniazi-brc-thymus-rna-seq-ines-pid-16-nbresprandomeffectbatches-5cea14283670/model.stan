data {
  int<lower=1> Ntotal; // number of observations
  int<lower=1> Nclusters1; // number of levels for group 1 for random intercepts
  int<lower=1> NScaleBatches1; // number of sub groups/batches of scale terms in cluster1
  int<lower=1> Nsizes; // number of size terms for controlling dispersion
  array[Ntotal] int<lower=1, upper=Nclusters1> NgroupMap1; // mapping variable to map each observation to group 1 
  array[Ntotal] int<lower=1, upper=Nsizes> NsizeMap; // mapping variable to map size to groups
  array[Nclusters1] int<lower=1, upper=NScaleBatches1> NBatchMap1; // expanding vector to map each variance term to the relevant 
                                                    // set of coefficients from rGroupsJitter1
  int<lower=1> Ncol; // total number of columns in model matrix
  array[Ntotal] int y; // response variable
  // additional parameters
  real gammaShape; // hyperparameters for the gamma distribution 
  real gammaRate;
  real intercept;
  real intercept_sd;
}
// transformed data {
  // }
parameters {
  // parameters to estimate in the model
  vector[Ncol] betas; // regression intercept 
  array[NScaleBatches1] real<lower=0.01> sigmaRan1; // random effect standard deviations for sub-batches in group 1
  array[Nsizes] real<lower=1, upper=1000> iSize; // size parameter for the nb distribution
  vector[Nclusters1] rGroupsJitter1; // number of random jitters for each level of cluster/group 1
}
transformed parameters {
  vector[Ntotal] mu; // fitted values from linear predictor
  mu = exp(betas[1] + rGroupsJitter1[NgroupMap1]);
}
model {
  array[Nclusters1] real sigmaRan1_expanded;
  sigmaRan1 ~ gamma(gammaShape, gammaRate);
  betas ~ normal(intercept, intercept_sd);
  // random effects sample
  sigmaRan1_expanded = sigmaRan1[NBatchMap1];
  rGroupsJitter1 ~ normal(0, sigmaRan1_expanded);
  // likelihood function
  y ~ neg_binomial_2(mu, iSize[NsizeMap]);
}
