data {
	int<lower=1>n;
    int<lower=1>N;
    int<lower=1>M;
	array[n] int<lower=1> I;
	array[n] int<lower=1> J;
    array[n] real y;
    real<lower=0> df;
	real<lower=0> beta;
    array[N] real<lower=0> tau;
    array[N] real b;
}

parameters {
    array[N] real B;
    array[M] real G;
    array[N] real<lower=0> sigma2;
}

transformed parameters {
    array[n] real mu;
	for (k in 1:n){
		mu[k] = B[I[k]] + G[J[k]] - sigma2[I[k]]/2;
	}
}

model {
    for (k in 1:n){
        y[k] ~ normal(mu[k], sqrt(sigma2[I[k]]));
	}
	for (i in 1:N){
        B[i] ~ normal(b[i], tau[i]);
		sigma2[i] ~ inv_gamma(df, beta);
    }
}
