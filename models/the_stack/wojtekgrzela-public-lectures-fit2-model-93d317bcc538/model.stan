data 
{
	int N; 
	array[N] int deaths; 
	vector[N] Miles;
}

parameters 
{
	real beta;
}

transformed parameters 
{
	vector[N] lambda = Miles * beta;
}

model 
{
	beta ~ beta(2,10);
	deaths ~ poisson(lambda);
}

generated quantities 
{
	array[N] int death;
	for (i in 1:N) {
		death[i] = poisson_rng(lambda[i]);
	}
}

