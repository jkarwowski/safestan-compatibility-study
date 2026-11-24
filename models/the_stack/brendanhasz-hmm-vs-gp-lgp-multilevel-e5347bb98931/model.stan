data {
  int<lower=1> N;  //number of datapoints per trial
  int<lower=1> Nt; //number of trials (total across all subjects)
  int<lower=1> Ns; //number of subjects
  array[N] real x;       //independent var (same across trials/subjects)
  array[Nt] int<lower=1,upper=Ns> S; //subject ID for each trial
  array[Nt] row_vector<lower=0, upper=1>[N] y; //dependent variable
}

transformed data {
  vector[N] mu;      //mean function (vector of 0s)
  real sum_ln_scale; //sum of scales for logit normal dists
  mu = rep_vector(0, N);
  sum_ln_scale = 0;
  for (i in 1:Nt) //pre-compute contribution of logit normal scales
    sum_ln_scale += -sum(log(y[i])+log(1-y[i]));
}

parameters {
  // Per-subject parameters (non-centered parameterization)
  array[Ns] real rho_tilde;   //non-centered std of length scale
  array[Ns] real alpha_tilde; //non-centered std of signal std dev
  array[Ns] real sigma_tilde; //non-centered std of noise std dev
  
  // Population-level parameters
  real<lower=0> rho_m;   //median of rho population distribution
  real<lower=0> rho_s;   //std of rho population distribution
  real<lower=0> alpha_m; //median of alpha population distribution
  real<lower=0> alpha_s; //std of alpha population distribution
  real<lower=0> sigma_m; //median of sigma population distribution
  real<lower=0> sigma_s; //std of sigma population distribution
}

transformed parameters {
  // Per-subject parameters
  array[Ns] real<lower=0> rho;   //length scale
  array[Ns] real<lower=0> alpha; //signal standard deviation
  array[Ns] real<lower=0> sigma; //noise standard deviation
  
  // Non-centered parameterization of per-subject parameters
  for (s in 1:Ns) {
    rho[s] = exp(log(rho_m) + rho_s * rho_tilde[s]);
    alpha[s] = exp(log(alpha_m) + alpha_s * alpha_tilde[s]);
    sigma[s] = exp(log(sigma_m) + sigma_s * sigma_tilde[s]);
  }
}

model {
  
  // Covariance matrix for each subject (assume x same for each trial)
  array[Ns] matrix[N, N] K;
  for (s in 1:Ns) {
    K[s] = gp_exp_quad_cov(x, alpha[s], rho[s]) + 
           diag_matrix(rep_vector(square(sigma[s]), N));
  }

  // Priors (on population-level params)
  target += inv_gamma_lpdf(rho_m | 2, 0.5);
  target += normal_lpdf(alpha_m | 0, 2)   + log(2);
  target += normal_lpdf(sigma_m | 0, 1)   + log(2);
  target += normal_lpdf(rho_s   | 0, 0.5) + log(2);
  target += normal_lpdf(alpha_s | 0, 0.5) + log(2);
  target += normal_lpdf(sigma_s | 0, 0.5) + log(2);
  
  // Subject-level parameters drawn from pop-level distributions
  // (non-centered parameterizations)
  target += normal_lpdf(rho_tilde   | 0, 1); //log(rho) ~ normal(exp(rho_m), rho_s)
  target += normal_lpdf(alpha_tilde | 0, 1); //log(alpha) ~ normal(exp(alpha_m), alpha_s)
  target += normal_lpdf(sigma_tilde | 0, 1); //log(sigma) ~ normal(exp(sigma_m), sigma_s)
  
  // Jacobian adjustments for GLM parts of model
  target += -sum(log(rho));
  target += -sum(log(alpha));
  target += -sum(log(sigma));
  
  // Accumulate evidence over trials
  for (i in 1:Nt)
    target += multi_normal_lpdf(logit(y[i]) | mu, K[S[i]]);
    
  // Add logit-normal scale terms to log posterior
  target += sum_ln_scale;
  
}
