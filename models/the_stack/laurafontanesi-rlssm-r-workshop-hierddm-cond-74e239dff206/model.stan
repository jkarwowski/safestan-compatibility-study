data {
	int<lower=1> N;									// number of data items
	int<lower=1> L;									// number of levels
	int<lower=1> C;									// number of conditions
	array[N] int<lower=1, upper=L> participant;			// level (participant)
	array[N] int<lower=1, upper=C> condition;				// condition
	array[N] int<lower=-1,upper=1> accuracy;				// accuracy (-1, 1)
	array[N] real<lower=0> rt;							// rt
	real<lower=0, upper=1> starting_point;			// starting point diffusion model not to estimate
}
parameters {
	array[C] real mu_drift;
	array[C] real mu_threshold;
	real mu_ndt;

	array[C] real<lower=0> sd_drift;
	array[C] real<lower=0> sd_threshold;
	real<lower=0> sd_ndt;

	array[L] vector[C] z_drift;
	array[L] vector[C] z_threshold;
	array[L] real z_ndt;
}
transformed parameters {
	array[N] real drift_ll;								// trial-by-trial drift rate for likelihood (incorporates accuracy)
	array[N] real drift_t;								// trial-by-trial drift rate for predictions
	array[N] real<lower=0> threshold_t;					// trial-by-trial threshold
	array[N] real<lower=0> ndt_t;							// trial-by-trial ndt

	array[L] vector[C] drift_sbj;
	array[L] vector[C] threshold_sbj;
	array[L] real<lower=0> ndt_sbj;
	
	for (l in 1:L) {
		for (c in 1:C) {
			drift_sbj[l][c] = mu_drift[c] + z_drift[l][c]*sd_drift[c];
			threshold_sbj[l][c] = log(1 + exp(mu_threshold[c] + z_threshold[l][c]*sd_threshold[c]));
		}
		ndt_sbj[l] = log(1 + exp(mu_ndt + z_ndt[l]*sd_ndt));
	}

	for (n in 1:N) {
		drift_t[n] = drift_sbj[participant[n]][condition[n]];
		drift_ll[n] = drift_t[n]*accuracy[n];
		threshold_t[n] = threshold_sbj[participant[n]][condition[n]];
		ndt_t[n] = ndt_sbj[participant[n]];
	}
}
model {
	mu_drift ~ normal(0, 3);
	mu_threshold ~ normal(0, 5);
	mu_ndt ~ normal(-1, 3);

	sd_drift ~ normal(0, 3);
	sd_threshold ~ normal(0, 5);
	sd_ndt ~ normal(0, 1);

	for (l in 1:L) {
		z_drift[l] ~ normal(0, 1);
		z_threshold[l] ~ normal(0, 1);
		z_ndt[l] ~ normal(0, 1);
	}

	rt ~ wiener(threshold_t, ndt_t, starting_point, drift_ll);
}
generated quantities {
	vector[N] log_lik;

	{for (n in 1:N) {
		log_lik[n] = wiener_lpdf(rt[n] | threshold_t[n], ndt_t[n], starting_point, drift_ll[n]);
	}
}
}