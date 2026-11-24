data {
  int<lower=0> N; 
  int<lower=0> K;
  array[N] row_vector[K] X; 
  array[N] real Y; 
  int<lower=0> J;
  array[N] int<lower=0, upper=J> uu;
}
parameters {
	cholesky_factor_corr[K] L;
	vector<lower=0>[K] tau;
	real<lower=0> sig_e;
	vector[K] beta; 
	array[J] vector[K] Z;
}
transformed parameters {
  vector[N] mu; 
  array[J] vector[K] U;
  matrix[K,K] SIGMA; 
  
  SIGMA = diag_pre_multiply(tau, L); // generate cholesky of Covariance matrix
  
  for(j in 1:J)
    U[j] = SIGMA*Z[j];               // multiply by uncorrelated deviates to get correlated random effects 
    
  for(i in 1:N)  
    mu[i] = X[i]*(beta + U[uu[i]]); 
}
model {
  //###  PRIORS
  L ~ lkj_corr_cholesky(2.0);
  
  tau ~ cauchy(0,2.5);
  sig_e ~ cauchy(0,2.5);
  beta ~ normal(0,1);
  
  for(j in 1:J)
    Z[j] ~ normal(0,1);
  
  //###  LIKELIHOOD
  Y ~ normal(mu, sig_e); // observations vary normally around expected values
}
