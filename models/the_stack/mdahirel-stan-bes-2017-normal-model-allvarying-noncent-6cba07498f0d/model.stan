/*
Hierarchical linear model with normal regression for
any number of predictor variables, all varying according to one grouping level
with weakly informative priors on the betas and on the standard deviation
using a 
*/
data{
	int<lower=1> N; //number of observations
	int<lower=1> K; //number of predictor variables NOT including the intercept
	matrix[N,K] X; //the model matrix including the intercept
	int<lower=1> N_group;//number of group for the varying intercept
	array[N] int<lower=1,upper=N_group> ID_group;//index variable for group ID
	vector[N] y; //the response variable
}

parameters{
	vector[K] mu; //the population-level regression parameters
	cholesky_factor_corr[K] L; //correlation between varying effects
	vector<lower=0>[K] tau; //variation of the varying effects
	
	
	matrix[N_group, K] z;//matrix for the non-centered parametrization
	
	real<lower=0> sigma_residuals;//the variation of the residuals

	//vector[N_group] error; //for the non-centered parametrization	
}
transformed parameters{
	
	//matrix[K,K] L_Sigma; //the variance-covariance matrix between the varying effects
	matrix[N_group,K] beta;//matrix of group-level effects
	
	beta = rep_matrix(mu, N_group)' + (z * diag_pre_multiply(tau, L));//this is equivalent to: beta~multi_normal(mu,Sigma)
}

model{
	tau ~ cauchy(0, 2.5); //prior for the scale
	L ~ lkj_corr_cholesky(2); // prior on the cholesky matrix
	mu ~ normal(0, 5);

	to_vector(z) ~ normal(0, 1);//standard normal values, easier to sample than a multi-normal distribution

	y ~ normal(rows_dot_product(beta[ID_group],X), sigma_residuals);
}

generated quantities{
	//vector[N] y_gen;
	matrix[K,K] Sigma; //the variance-covariance matrix of the varying effects
	//for(n in 1:N)
	//	y_gen[n] = normal_rng(X[n] * beta[ID_group[n]],sigma_residuals);

	
	Sigma = tcrossprod(diag_pre_multiply(tau,L));

}


