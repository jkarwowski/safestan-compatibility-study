data {
  int<lower=0> n; // number of observations
  int<lower=0> dimension; // number of covariates
  matrix[n,dimension] x; // Matrix of covariates
  array[n] int<lower=0,upper=1> y; // Responses
  vector[dimension] prior_mean;
  matrix[dimension,dimension] prior_cov;
}
parameters {
  vector[dimension] beta;
}
model {
  beta ~ multi_normal(prior_mean, prior_cov);
  y ~ bernoulli_logit(x * beta); // Logistic regression
}
