data {
	int<lower=1>n;
    int<lower=1>N;
    int<lower=1>M;
	array[n] int<lower=1> I;
	array[n] int<lower=1> J;
    array[n] real y;
    real sigma;
    real nu;
    array[N] real<lower=0> tau;
    array[N] real b;
}

parameters {
    array[N] real B;
    array[M] real G;
    array[n] real<lower=0> xi;
}

transformed parameters {
    array[n] real mu;
	for (k in 1:n){
		mu[k] = B[I[k]] + G[J[k]] - sigma*sigma/(2*xi[k]);
	}
}

model {
    for (k in 1:n){
        y[k] ~ normal(mu[k], sigma/sqrt(xi[k]));
		xi[k] ~ chi_square(nu);
	}
	for (i in 1:N){
        B[i] ~ normal(b[i], tau[i]);
    }
}