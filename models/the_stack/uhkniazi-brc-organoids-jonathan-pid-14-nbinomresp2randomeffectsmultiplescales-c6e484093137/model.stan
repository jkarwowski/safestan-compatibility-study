data {
  int<lower=1> Ntotal; // number of observations
  int<lower=1> Nclusters1; // number of levels for group 1 for random intercepts
  int<lower=1> Nclusters2; // number of levels for group 2 for random intercepts
  //int<lower=1> Nclusters3; // number of levels for group 3 for random intercepts
  int<lower=1> Nclusters1_variance; // number of lower level variance terms mapping to groups of jitters from group 1
  int<lower=1> Nsizes; // number of size terms for controlling dispersion
  array[Ntotal] int<lower=1, upper=Nclusters1> NgroupMap1; // mapping variable to map each observation to group 1 
  array[Ntotal] int<lower=1, upper=Nclusters2> NgroupMap2; // mapping variable to map each observation to group 2
  //int<lower=1, upper=Nclusters3> NgroupMap3[Ntotal]; // mapping variable to map each observation to group 3
  array[Nclusters1] int<lower=1> rGroupsJitter1Map; // mapping variance terms to their coefficients in group 1
  array[Ntotal] int<lower=1, upper=Nsizes> NsizeMap; // mapping variable to map size to genes
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
  vector[1] betas; // regression intercept 
  array[Nclusters1_variance] real<lower=0.1> sigmaRan1; // random effect standard deviation for group 1
  real<lower=0.01> sigmaRan2; // random effect standard deviation for group 2
  //real<lower=0> sigmaRan3; // random effect standard deviation for group 3
  array[Nsizes] real<lower=1, upper=100> iSize; // size parameter for the nb distribution
  vector[Nclusters1] rGroupsJitter1; // number of random jitters for each level of cluster/group 1
  vector[Nclusters2] rGroupsJitter2; // number of random jitters for each level of cluster/group 2
  //vector[Nclusters3] rGroupsJitter3; // number of random jitters for each level of cluster/group 3
}
transformed parameters {
  vector[Ntotal] mu; // fitted values from linear predictor
  mu = exp(betas[1] + rGroupsJitter1[NgroupMap1] + rGroupsJitter2[NgroupMap2]*sigmaRan2);// + rGroupsJitter3[NgroupMap3]);
}
model {
  array[Nclusters1] real sigmaRan1_expanded;
  sigmaRan1 ~ gamma(gammaShape, gammaRate);
  sigmaRan2 ~ gamma(gammaShape, gammaRate);
  //sigmaRan3 ~ gamma(gammaShape, gammaRate);
  betas ~ normal(intercept, intercept_sd);
  // random effects sample
  sigmaRan1_expanded = sigmaRan1[rGroupsJitter1Map];
  rGroupsJitter1 ~ normal(0, sigmaRan1_expanded);
  rGroupsJitter2 ~ normal(0, 1);
  //rGroupsJitter3 ~ normal(0, sigmaRan3);
  // likelihood function
  y ~ neg_binomial_2(mu, iSize[NsizeMap]);
}
