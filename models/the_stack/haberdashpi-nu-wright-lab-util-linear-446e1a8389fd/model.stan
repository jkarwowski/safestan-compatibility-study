data{
  int<lower=1> n; // number of observations
  int<lower=0> k; // number of predictors
  array[n] real y; // outcomes
  matrix[n,k] A; // predictiors
  real fixed_mean_prior;
  real prediction_error_prior;
}
parameters{
  vector[k] alpha;
  real<lower=0> eps;
}
model{
  eps ~ normal(0,prediction_error_prior);
  alpha ~ cauchy(0,fixed_mean_prior);
  y ~ normal(A*alpha,eps);
}