data {
    // number of observations
    int<lower=0> N;
    // dimensions of X
	int<lower=0> P;
	
	// Y must be integer
	array[N] int<lower=0> Y;
	// covariates already include intercept
	matrix[N, P] X;
	
	// predictions
    int<lower=0> N_test;
    matrix[N_test, P] X_test;
    array[N_test] int<lower=0> Y_test;
	
}

transformed data {
    int<lower=0> n_trials = max(Y);
    }

parameters {
    vector[P] beta;
}

model {
	beta ~ normal(0, 2);
    Y ~ binomial_logit(n_trials, X * beta);
}
generated quantities {
    vector[N_test] XB;
    array[N_test] real Y_pred;
    array[N_test] real loglik;
    
    XB = X_test * beta;
    
    Y_pred = binomial_rng(max(Y_test), inv_logit(XB));
    
    for (n in 1:N_test){
        loglik[n] = binomial_logit_lpmf(Y_test[n] | max(Y_test), XB[n]);
    }
}
