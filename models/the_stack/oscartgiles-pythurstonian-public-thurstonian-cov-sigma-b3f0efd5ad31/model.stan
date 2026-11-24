data { 
	int<lower = 1> N; //The number of data points
	int<lower=1> K;  // number of items being ranked 
	int<lower = 1> C; // The number of covariates
	int<lower = 1> J; //Number of raters

	array[N, K] int<lower=1,upper=K> y;   // y[i] is a vector of rankings for the ith data point
	matrix[N, C] X;
	array[N] int<lower = 1> rater; //Index the rater who produced rank i

	real<lower = 0> beta_sd_prior;
	real<lower = 0> scale_sd_prior;
} 

transformed data{
	array[N, K] int y_argsort;	
	array[N, K] int sort_y_argsort;

	for (i in 1:N){		
		y_argsort[i] = sort_indices_asc(y[i]);
		sort_y_argsort[i] = sort_indices_asc(y_argsort[i]);
	}

	
}

parameters { 
	array[N] ordered[K] z_hat;
	matrix[C, K-1] beta_zero; //matrix of differences from the first ranking (fixed at zero)
	vector<lower = 0>[J] sigma;
} 

transformed parameters{	

	matrix[N, K] mu_part;	

	mu_part = append_col(rep_vector(0, N), X * beta_zero);	
}

model{ 
	sigma ~ lognormal(0, scale_sd_prior);
	to_vector(beta_zero) ~ normal(0, beta_sd_prior);

	for (i in 1:N){				
			
		z_hat[i] ~ normal(mu_part[i, y_argsort[i]], sigma[rater[i]]); 
	}
	
} 

generated quantities{

	matrix[C, K] beta; 	
	//Prepend zeros to beta_zero
	beta = append_col(rep_vector(0.0, C), beta_zero);
}