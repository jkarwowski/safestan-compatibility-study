data {
	int<lower=2> C;                   // # of alternatives
	int<lower=1> N;	                  // # of individuals
	int<lower=1> K;                   // # of covariates of invdividuals
	int<lower=1> KC;                  // # of covariates of alternatives
	array[N] vector<lower=0,upper=1>[C] Z;  // # index if alternative was considered 
	array[N] matrix[C, K] X;                // matrix of attributes for each individual
	array[N] matrix[C, KC] X2;              // matrix of attributes for each alternatives
	array[N] vector<lower = 0, upper = 1>[C] choice; // binary indicator for final choice
}

parameters {
	vector[K] beta;       // individual attributes
	vector[KC] zeta;      // party attributes
}
model {
  matrix[C,N] xb;
  array[N] vector[C] utilities;
  array[N] vector[C] log_prob;
  
  // priors
	beta ~ normal(0, 5);  
	zeta ~ normal(0, 5);  

	// model
	for (i in 1:N){
	  xb[,i] = exp(X[i]*beta+X2[i]*zeta); // individual + alternative specific
	  utilities[i] = xb[,i] .* Z[i];      // set alternatives that were not considered to 0
	  
	  log_prob[i] = log(softmax(utilities[i]));
    target += log_prob[i] * choice[i]';
    
	  }
}
