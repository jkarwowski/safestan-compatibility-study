data 
{
	int N;
	array[N] int deaths;
}

parameters 
{
	real<lower=0> lambda;
}

model 
{
	lambda ~ normal(692,200);
	deaths ~ poisson(lambda);
}

generated quantities
{
	int death = poisson_rng(lambda);
}
