data {
  int<lower=1> n_obs;   // number of observed animals/groups
  int<lower=0> nz;      // number of zeros 
  int<lower=1> n_sites; //
  real<lower=0> B;      // max distance for study area
  array[n_obs+nz] int<lower=0> y; // ones for observed animals
  array[n_obs] int<lower=1,upper=n_sites> site; // site id
  array[n_obs] real<lower=0,upper=B> r;   // observed distances
  int<lower=1> K;   // number of env covariates
  int<lower=1> M;   // covariates for detection 
  //real<lower=0> Area;
  matrix[n_sites, K] X;             // env design matrix 
  matrix[n_sites, M] H;
}

transformed data{
}

parameters{
  array[nz] real<lower=0,upper=B> rsim;
  real alpha;
  real alpha_h;
  vector[K] beta;
  vector[M] beta_h;
}

transformed parameters{
  array[n_obs] real logit_p;
  matrix[nz, n_sites] logit_pz;
  real<lower=0,upper=1> psi;
  real lp0;
  vector[n_sites] log_lambda;
  vector[n_sites] sigma;
  {
    array[n_obs] real log_p;
    matrix[nz, n_sites] log_pz;
    
    for(s in 1:n_sites){
      log_lambda[s] = (log(alpha) + X[s,] * beta);
      sigma[s] = exp(log(alpha_h) + H[s,] * beta_h);
    }
    
    psi = sum(exp(log_lambda))/(n_obs + nz);
    lp0 = bernoulli_lpmf(0 | psi) ;
    
    for(i in 1:n_obs){
      log_p[i] = - r[i]^2/(2*sigma[site[i]]^2);
      logit_p[i] = log_p[i] - log1m_exp(log_p[i]);
    }
    
    for(j in 1:nz){
      for(s in 1:n_sites){
        log_pz[j,s] = - rsim[j]^2/(2*sigma[s]^2); 
        logit_pz[j,s] = log_pz[j,s] - log1m_exp(log_pz[j,s]);
      }
    }
  }
}

model { 
  rsim ~ uniform(0, B);
  alpha ~ normal(1,1);
  beta ~ normal(0,1);
  alpha_h ~ normal(1,1);
  beta_h ~ normal(0,1);
  
  {
    vector[n_sites] log_site_prob = log_softmax(log_lambda);
    vector[n_sites] site_prob = softmax(log_lambda);
    vector[n_sites + 1] lpsite =  to_vector(append_row(lp0, log_site_prob));
    
    for(n in 1: n_obs){
      target += bernoulli_lpmf(1 | psi) + bernoulli_logit_lpmf(1 | logit_p[n]);
      target += categorical_lpmf(site[n]|site_prob);
    }
    
    for(i in 1:nz){
      vector[n_sites + 1] lps = lpsite;
      for(s in 1:n_sites){
        lps[s+1] += bernoulli_lpmf(1 | psi) + bernoulli_logit_lpmf(0 | logit_pz[i,s]);
      }
      target += log_sum_exp(lps);
    }
  }
}

generated quantities{
  array[n_sites] int<lower=0> N;
  int<lower=0> Ntotal;
  
  for(i in 1:n_sites) N[i] = poisson_log_rng(log_lambda[i]);
  Ntotal = sum(N);
  
  //   real D = (n_obs+(nz*psi))/Area;
}
