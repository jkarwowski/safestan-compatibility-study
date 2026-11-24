data {
  int<lower=1> Ntotal; // number of observations
  int<lower=1> Ncol; // total number of columns in model matrix
  int<lower=1> NscaleBatches;
  matrix[Ntotal, Ncol] X; // model matrix
  array[Ntotal] real y; // response variable t distributed
  array[(Ncol-1)] int<lower=1, upper=NscaleBatches> NBatchMap; // mapping variable to model matrix columns
}
// transformed data {
  // }
parameters {
  // parameters to estimate in the model
  vector[Ncol] betas; // regression parameters
  real<lower=0> sigmaPop; // population level scale for t distribution
  array[NscaleBatches] real<lower=0.01> sigmaRan; // shared standard deviation for coefficients
  real<lower=1> nu; // normality parameter for t distribution or degree of freedom 
}
transformed parameters {
  vector[Ntotal] mu; // fitted values from linear predictor
  // fitted value
  mu = X * betas; 
}
model {
  array[(Ncol-1)] real sigmaRan_expanded;
  nu ~ exponential(1/29.0);
  // using diffuse prior
  sigmaPop ~ cauchy(0, 2);
  sigmaRan ~ cauchy(0, 2);
  betas[1] ~ cauchy(0, 2); //prior for the intercept
  // vector expansion by mapping to a larger vector/array
  sigmaRan_expanded = sigmaRan[NBatchMap];
  betas[2:Ncol] ~ normal(0, sigmaRan_expanded);
  // likelihood function
  y ~ student_t(nu, mu, sigmaPop);
}
