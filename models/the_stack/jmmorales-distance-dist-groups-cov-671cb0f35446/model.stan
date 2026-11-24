data {
  int<lower=1> n_obs;                     // number of observed animals/groups
  array[n_obs] int<lower=1> gr;                 // observed group size
  int<lower=0> nz;                        // number of zeros 
  int<lower=1> n_sites;                   //
  real<lower=0> B;                        // max distance for study area
  array[n_obs] int<lower=1,upper=n_sites> site; // site id for observed animals
  array[n_obs] real<lower=0,upper=B> r;         // observed distances
  int<lower=1> K;                         // number of env covariates
  matrix[n_sites, K] X;                   // env design matrix 
  //int<lower=1> max_gr;                  // max group size
}

transformed data{
  array[n_obs] int<lower=0> groupsize;
  int<lower=n_obs> m = n_obs + nz;
  for(i in 1:n_obs) groupsize[i] = gr[i]-1;
}

parameters{
  array[nz] real<lower=0,upper=B> rsim; // unobserved distances
  array[nz] real<lower=0> ugz;          // unobserved group size
  real alpha;
  real a_g;
  real b_g;
  vector[K] beta;
  real<lower=0> lambda_group;
}

transformed parameters{
  array[m] real log_p;
  array[m] real logit_p;
  array[m] real<lower=0> sigma;
  vector[n_sites] log_lambda;
  real<lower=0,upper=1> psi;
  real lp0;
  
  for(s in 1:n_sites){
    log_lambda[s] = alpha + X[s,] * beta;
  }
  
  psi = sum(exp(log_lambda))/(n_obs + nz);
  lp0 = bernoulli_lpmf(0 | psi) ;
  
  for(n in 1:n_obs){
    sigma[n] = exp(a_g + b_g * groupsize[n]);
    log_p[n] = - r[n]^2/(2*sigma[n]^2);
    logit_p[n] = log_p[n] - log1m_exp(log_p[n]);
  }
  
  for(j in (n_obs+1):m){
    sigma[j] = exp(a_g + b_g * ugz[j-n_obs]);
    log_p[j] = -rsim[j-n_obs]^2/(2*sigma[j]^2);
    logit_p[j] = log_p[j] - log1m_exp(log_p[j]);
  }
}

model { 

  rsim ~ uniform(0, B);
  lambda_group ~ normal(0,2);
  ugz ~ normal(lambda_group, sqrt(lambda_group));
  a_g ~ normal(0,1);
  b_g ~ normal(0,1);
  alpha ~ normal(1,2);
  beta ~ normal(1,1);
  
  {
    vector[n_sites] log_site_prob = log_softmax(log_lambda);
    vector[n_sites] site_prob = softmax(log_lambda);
    vector[n_sites + 1] lpsite =  to_vector(append_row(lp0, log_site_prob));
    
    for(n in 1: n_obs){
      target += bernoulli_lpmf(1 | psi) + bernoulli_logit_lpmf(1 | logit_p[n]);
      target += categorical_lpmf(site[n]|site_prob);
      target += poisson_lpmf(groupsize[n]|lambda_group);
    }
    
    for(i in 1:nz){
      vector[n_sites + 1] lps = lpsite;
      for(s in 1:n_sites){
        lps[s+1] += bernoulli_lpmf(1 | psi) + bernoulli_logit_lpmf(0 | logit_p[n_obs+i]);
      }
      target += log_sum_exp(lps);
    }
  }
}
//generated quantities{
  //   real D = (n_obs+(nz*psi))/Area;
  // }
  