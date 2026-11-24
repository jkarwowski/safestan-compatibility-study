data{
  int n_samples;                          // Number of datapoints
  int n_covariates;                       // Number of covariates
  matrix[n_samples, n_covariates] X;      // Matrix of covariate values
  array[n_samples] real y;                      // survival outcomes
}
parameters{
  real<lower=0> alpha;
  real beta0;
  vector[n_covariates] beta;
}
model{
  beta0 ~ normal(0,0.05);
  beta ~ normal(0,0.05);
  y~weibull(alpha, exp(X*beta + beta0));
}
generated quantities{
  array[n_samples] real yppf;
  
  yppf = weibull_rng(alpha, exp(X*beta + beta0));
}
