/*
lognormal distribution 
by-subject and by-item intercepts (no random slopes; see Vasishth et al. 2017)
model for NP complexity effect as typically assessed in the literature
*/

data {
	int<lower=1> N;                    // Number of observations
	real<lower=0> y[N];  		            //outcome
	int<lower=0, upper=1> nounphrase[N];  //predictor
	
	int<lower=1> S;                  //number of subjects
	int<lower=1, upper=S> subj[N];   //subject id

	int<lower=1> I;                  //number of items
	int<lower=1, upper=I> items[N];   //items id
}


parameters {
  real beta;
	real<lower=0> sigma;		// residual sd

  // Non-centre intercept
  real alpha_mu; // distribution
  real<lower=0> alpha_sigma;
  real alpha_raw;

	// For random effects
  vector<lower=0>[2] sigma_u;
  cholesky_factor_corr[2] L_u; 
  matrix[2,S] z_u;

  vector<lower=0>[2] sigma_w;
  cholesky_factor_corr[2] L_w; 
  matrix[2,I] z_w;
}


transformed parameters{
  vector[N] mu;
	real alpha = alpha_mu + alpha_sigma*alpha_raw;
  matrix[2,S] u = diag_pre_multiply(sigma_u, L_u) * z_u; //subj random effects
  matrix[2,I] w = diag_pre_multiply(sigma_w, L_w) * z_w; //item random effects

  for(n in 1:N){
    mu[n] = alpha + nounphrase[n]*beta + u[nounphrase[n]+1, subj[n]] + w[nounphrase[n]+1, items[n]];
  }
}


model {
	// Priors
	alpha_mu ~ normal(6, 3);
	alpha_sigma ~ normal(0, 10);
	alpha_raw ~ normal(0, 1);

	beta ~ normal(0, 1);
	sigma ~ cauchy(0, 2.5); 
	
  // REs priors
	L_u ~ lkj_corr_cholesky(2.0);
	to_vector(z_u) ~ normal(0,1);
  sigma_u ~ normal(0,2.5);

	L_w ~ lkj_corr_cholesky(2.0);
	to_vector(z_w) ~ normal(0,1);
  sigma_w ~ normal(0,2.5);

	// Likelihood
	y ~ lognormal(mu, sigma);
}

generated quantities {
  vector[N] log_lik;
  vector[N] y_tilde;
  real alpha2 = alpha + beta;

  for (n in 1:N) {
    log_lik[n] = lognormal_lpdf(y[n] | mu[n], sigma);
    y_tilde[n] = lognormal_rng(mu[n], sigma);
  }
}
