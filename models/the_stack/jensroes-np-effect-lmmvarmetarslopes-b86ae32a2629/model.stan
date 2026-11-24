/*
lognormal distribution 
by-subject and by-item intercepts (no random slopes; see Vasishth et al. 2017)
model for NP complexity effect 
heteroscedasticity for np conditions
*/

data {
	int<lower=1> N;                    // Number of observations
	array[N] real<lower=0> y;  		            //outcome
	array[N] int<lower=0, upper=1> nounphrase;  //predictor
	
	int<lower=0> E;  // Number of experiments
	array[N] int<lower=0, upper=E> exps;  // Number of experiments

	int<lower=1> S;                  //number of subjects
	array[N] int<lower=1, upper=S> subj;   //subject id

	int<lower=1> I;                  //number of items
	array[N] int<lower=1, upper=I> items;   //items id
}


parameters {
  real beta; // effect across all experiments
  real<lower=0> tau; // variation between experiments
  vector[E] eta;

	real<lower=0> sigma;		// residual sd
	vector<lower=0>[E] sigma_diff;

  // Non-centre intercept
  real alpha_mu; // distribution
  real<lower=0> alpha_sigma;
  vector[E] alpha_raw;

	// For random effects
  vector<lower=0>[2] sigma_u;
  cholesky_factor_corr[2] L_u; 
  matrix[2,S] z_u;

  vector<lower=0>[2] sigma_w;
  cholesky_factor_corr[2] L_w; 
  matrix[2,I] z_w;


}


transformed parameters{
  vector[E] betae = beta + tau * eta; // effect for each experiment
	vector[E] alpha = alpha_mu + alpha_sigma * alpha_raw;
	vector<lower=0>[E] sigmap_e = sigma + sigma_diff;
	vector<lower=0>[E] sigma_e = sigma - sigma_diff;
	matrix[2,S] u = diag_pre_multiply(sigma_u, L_u) * z_u; //subj random effects
  matrix[2,I] w = diag_pre_multiply(sigma_w, L_w) * z_w; //item random effects

}

  

model {
	// Priors
	alpha_mu ~ normal(7, 3);
	alpha_sigma ~ normal(0, 10);
	alpha_raw ~ normal(0, 1);
  
	sigma ~ cauchy(0, 2.5); 

	beta ~ normal(0, 10);
  tau ~ cauchy(0, 1);
  eta ~ normal(0, 1);
	
  sigma_diff ~ normal(0,1);

  
  // REs priors
	L_u ~ lkj_corr_cholesky(2.0);
	to_vector(z_u) ~ normal(0,1);
  sigma_u ~ normal(0,2.5);

	L_w ~ lkj_corr_cholesky(2.0);
	to_vector(z_w) ~ normal(0,1);
  sigma_w ~ normal(0,2.5);

	// Likelihood
	for(n in 1:N){
	  real mu = alpha[exps[n]] + u[nounphrase[n]+1, subj[n]] + w[nounphrase[n]+1,items[n]];
    if(nounphrase[n]==0){
  	  y[n] ~ lognormal(mu, sigma_e[exps[n]]);
    }
    if(nounphrase[n]==1){
  	  y[n] ~ lognormal(mu + betae[exps[n]], sigmap_e[exps[n]]);
    }
	}
}

generated quantities {
  vector[N] log_lik;
  vector[N] y_tilde;
  real alpha2 = alpha_mu + beta;
  vector[E] alpha2e = alpha + betae;

  for (n in 1:N) {
	  real mu = alpha[exps[n]] + u[nounphrase[n]+1, subj[n]] + w[nounphrase[n]+1,items[n]];
    if(nounphrase[n]==0){
      log_lik[n] = lognormal_lpdf(y[n] | mu, sigma_e[exps[n]]);
      y_tilde[n] = lognormal_rng(mu, sigma_e[exps[n]]);
    }
    if(nounphrase[n]==1){
      log_lik[n] = lognormal_lpdf(y[n] | mu + betae[exps[n]], sigmap_e[exps[n]]);
      y_tilde[n] = lognormal_rng(mu + betae[exps[n]], sigmap_e[exps[n]]);
    }
  }
}
