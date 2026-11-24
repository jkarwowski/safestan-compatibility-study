data {
	int<lower=0> N;
	array[N] real<upper=10> grp1;
	array[N] real<upper=10> grp2;
}

parameters {
	real<lower=0> sigma;
	real mu;
}

model {
	for (i in 1:N)
		grp2[i] ~ normal(grp1[i] + mu, sigma);
}
