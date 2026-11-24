/*
  lognormal distribution 
  by-subject and by-item intercepts (no random slopes; see Vasishth et al. 2017)
  model for NP complexity effect 
  heteroscedasticity for np conditions
*/
  
data {
  int<lower=1> N;                    // Number of observations
  real<lower=0> y[N];  		            //outcome
  int<lower=0, upper=1> nounphrase[N];  //predictor
	int<lower=1, upper=2> modality[N];
	int<lower=1, upper=4> cond[N]; // combination of nounphrase and modality for random slopes

  int<lower=0> E;  // Number of experiments
  int<lower=0, upper=E> exps[N];  // Number of experiments
  
  int<lower=1> S;                  //number of subjects
  int<lower=1, upper=S> subj[N];   //subject id
  
  int<lower=1> I;                  //number of items
  int<lower=1, upper=I> items[N];   //items id
}


parameters {
  real beta; // effect across all experiments
  real<lower=0> tau; // variation between experiments
  vector[E] eta;
  
  real beta_writing; // effect across all experiments by modality
  real beta_speech; 
  real psi;

  real<lower=0> sigma_speech;		// residual sd
  vector<lower=0>[E] sigma_diff_speech;
  real<lower=0> sigma_writing;		// residual sd
  vector<lower=0>[E] sigma_diff_writing;
  
  // Non-centre intercept
  real alpha_mu; // distribution
  real<lower=0> alpha_sigma;
  vector[E] alpha_raw;
  
	// For random effects
  vector<lower=0>[4] sigma_u;
  cholesky_factor_corr[4] L_u; 
  matrix[4,S] z_u;

  vector<lower=0>[4] sigma_w;
  cholesky_factor_corr[4] L_w; 
  matrix[4,I] z_w;
}


transformed parameters{
  vector[E] beta_speech_e = beta_speech + tau * eta; // effect for each experiment
  vector[E] beta_writing_e = beta_writing + tau * eta; // effect for each experiment
  vector[E] alpha = alpha_mu + alpha_sigma * alpha_raw;
  
  vector<lower=0>[E] sigmap_e_speech = sigma_speech + sigma_diff_speech;
  vector<lower=0>[E] sigma_e_speech = sigma_speech - sigma_diff_speech;
  vector<lower=0>[E] sigmap_e_writing = sigma_writing + sigma_diff_writing;
  vector<lower=0>[E] sigma_e_writing = sigma_writing - sigma_diff_writing;

  matrix[4,S] u = diag_pre_multiply(sigma_u, L_u) * z_u; //subj random effects
  matrix[4,I] w = diag_pre_multiply(sigma_w, L_w) * z_w; //item random effects
}



model {
  // Priors
  alpha_mu ~ normal(7, 3);
  alpha_sigma ~ normal(0, 10);
  alpha_raw ~ normal(0, 1);
  
  sigma_writing ~ cauchy(0, 2.5); 
  sigma_diff_writing ~ normal(0,1);
  sigma_speech ~ cauchy(0, 2.5); 
  sigma_diff_speech ~ normal(0,1);
  
	// Hyper priors	
	beta_speech ~ normal(beta, psi);
	beta_writing ~ normal(beta, psi);
	
  // Hyper hyper priors
  beta ~ normal(0, 5);
  tau ~ normal(0, 1);
  eta ~ normal(0, 1);
  psi ~ normal(0, 1);
  
  // REs priors
	L_u ~ lkj_corr_cholesky(2.0);
	to_vector(z_u) ~ normal(0,1);
  sigma_u ~ normal(0,2.5);

	L_w ~ lkj_corr_cholesky(2.0);
	to_vector(z_w) ~ normal(0,1);
  sigma_w ~ normal(0,2.5);
  
  // Likelihood
  for(n in 1:N){
    real mu = alpha[exps[n]] + u[cond[n],subj[n]] + w[cond[n],items[n]];
    if(modality[n]==1){// speech
      if(nounphrase[n]==0){
        y[n] ~ lognormal(mu, sigma_e_speech[exps[n]]);    
      }
      if(nounphrase[n]==1){
        y[n] ~ lognormal(mu + beta_speech_e[exps[n]], sigmap_e_speech[exps[n]]);    
      }
    }
    if(modality[n]==2){// writing
      if(nounphrase[n]==0){
        y[n] ~ lognormal(mu, sigma_e_writing[exps[n]]);    
      }
      if(nounphrase[n]==1){
        y[n] ~ lognormal(mu + beta_writing_e[exps[n]], sigmap_e_writing[exps[n]]);    
      }
    }
  }
}

generated quantities {
  vector[N] log_lik;
  vector[N] y_tilde;
  vector[E] alpha2_speech_e = alpha + beta_speech_e;
  vector[E] alpha2_writing_e = alpha + beta_writing_e;
  real alpha2_speech = alpha_mu + beta_speech;
  real alpha2_writing = alpha_mu + beta_writing;
  real alpha2 = alpha_mu + beta;

  for (n in 1:N) {
    real mu = alpha[exps[n]] + u[cond[n],subj[n]] + w[cond[n],items[n]];
    if(modality[n]==1){// speech
      if(nounphrase[n]==0){
        log_lik[n] = lognormal_lpdf(y[n] | mu, sigma_e_speech[exps[n]]);
        y_tilde[n] = lognormal_rng(mu, sigma_e_speech[exps[n]]);
      }
      if(nounphrase[n]==1){
          log_lik[n] = lognormal_lpdf(y[n] | mu + beta_speech_e[exps[n]], sigmap_e_speech[exps[n]]);
          y_tilde[n] = lognormal_rng(mu + beta_speech_e[exps[n]], sigmap_e_speech[exps[n]]);
      }
    }
    if(modality[n]==2){// writing
      if(nounphrase[n]==0){
        log_lik[n] = lognormal_lpdf(y[n] | mu, sigma_e_writing[exps[n]]);
        y_tilde[n] = lognormal_rng(mu, sigma_e_writing[exps[n]]);
      }
      if(nounphrase[n]==1){
        log_lik[n] = lognormal_lpdf(y[n] | mu + beta_writing_e[exps[n]], sigmap_e_writing[exps[n]]);
        y_tilde[n] = lognormal_rng(mu + beta_writing_e[exps[n]], sigmap_e_writing[exps[n]]);
      }
    }
  }
}
