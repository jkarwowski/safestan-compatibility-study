// Sensitivity to prior distributions: application to Magnesium meta-analysis
//  http://www.openbugs.net/Examples/Magnesium.html

// prior specification 1, 2, 3, 4, 5, and 6 combined  
// in one posterior distribution.  
// For individual model specification, see magnesium$i.stan ($i=1,...,6)

//
// Note: tau is really the standard deviation parameter in the normal distribution.
//
data {
  int N_studies;
  array[N_studies] int rt;
  array[N_studies] int nt;
  array[N_studies] int rc;
  array[N_studies] int nc;
  array[6, N_studies] int rt_safestan_by_prior;
  array[6, N_studies] int rc_safestan_by_prior;
  array[6 * N_studies] int rt_safestan_flat;
  array[6 * N_studies] int rc_safestan_flat;
}
transformed data {
  int N_priors;
  real<lower=0> s0_sq;
  real<lower=0> p0_sigma;
  array[6, N_studies] int nt_by_prior;
  array[6, N_studies] int nc_by_prior;
  array[6 * N_studies] int nt_safestan_flat;
  array[6 * N_studies] int nc_safestan_flat;
  
  N_priors = 6;
  s0_sq = 0.1272041;
  p0_sigma = 1 / sqrt(Phi(0.75) / s0_sq);
  for (prior in 1 : 6) {
    for (i in 1 : N_studies) {
      nt_by_prior[prior, i] = nt[i];
      nc_by_prior[prior, i] = nc[i];
      nt_safestan_flat[(prior - 1) * N_studies + i] = nt[i];
      nc_safestan_flat[(prior - 1) * N_studies + i] = nc[i];
    }
  }
}
parameters {
  array[N_priors] real<lower=-10, upper=10> mu;
  vector[N_priors * N_studies] theta_raw;
  vector<lower=0, upper=1>[N_priors * N_studies] pc_raw;
  real<lower=0> inv_tau_sq_1;
  real<lower=0, upper=50> tau_sq_2;
  real<lower=0, upper=50> tau_3;
  real<lower=0, upper=1> B0;
  real<lower=0, upper=1> D0;
  real<lower=0> tau_sq_6;
}
transformed parameters {
  array[N_priors] real<lower=0> tau;
  array[N_priors, N_studies] real theta;
  array[N_priors, N_studies] real<lower=0, upper=1> pc;
  
  tau[1] = 1 / sqrt(inv_tau_sq_1);
  tau[2] = sqrt(tau_sq_2);
  tau[3] = tau_3;
  tau[4] = sqrt(s0_sq * (1 - B0) / B0);
  tau[5] = sqrt(s0_sq) * (1 - D0) / D0;
  tau[6] = sqrt(tau_sq_6);
  for (prior in 1 : N_priors) {
    for (i in 1 : N_studies) {
      theta[prior, i] = theta_raw[(prior - 1) * N_studies + i];
      pc[prior, i] = pc_raw[(prior - 1) * N_studies + i];
    }
  }
}
model {
  array[N_priors, N_studies] real mu_for_theta;
  array[N_priors, N_studies] real tau_for_theta;
  array[N_priors, N_studies] real tmpm;
  vector[N_priors * N_studies] mu_for_theta_flat;
  vector[N_priors * N_studies] tau_for_theta_flat;
  vector[N_priors * N_studies] tmpm_flat;
  
  // prior 1: gamma(0.001, 0.001) on inv_tau_sq
  inv_tau_sq_1 ~ gamma(0.001, 0.001);
  
  // Prior 2: Uniform(0, 50) on tau.sqrd
  tau_sq_2 ~ uniform(0, 50);
  
  // Prior 3: Uniform(0, 50) on tau
  tau_3 ~ uniform(0, 50);
  
  // Prior 4: Uniform shrinkage on tau.sqrd
  B0 ~ uniform(0, 1);
  
  // Prior 5: Dumouchel on tau
  D0 ~ uniform(0, 1);
  
  // Prior 6: Half-Normal on tau.sqrd
  tau_sq_6 ~ normal(0, p0_sigma) T[0, ];
  
  mu ~ uniform(-10, 10);
  pc_raw ~ uniform(0, 1);
  
  for (prior in 1 : N_priors) {
    for (i in 1 : N_studies) {
      mu_for_theta[prior, i] = mu[prior];
      tau_for_theta[prior, i] = tau[prior];
      mu_for_theta_flat[(prior - 1) * N_studies + i] = mu_for_theta[prior, i];
      tau_for_theta_flat[(prior - 1) * N_studies + i] = tau_for_theta[prior, i];
    }
  }
  theta_raw ~ normal(mu_for_theta_flat, tau_for_theta_flat);
  
  for (prior in 1 : N_priors) {
    for (i in 1 : N_studies) {
      tmpm[prior, i] = theta[prior, i] + logit(pc[prior, i]);
      tmpm_flat[(prior - 1) * N_studies + i] = tmpm[prior, i];
    }
  }
  rc_safestan_flat ~ binomial(nc_safestan_flat, pc_raw);
  rt_safestan_flat ~ binomial_logit(nt_safestan_flat, tmpm_flat);
}
generated quantities {
  array[N_priors] real OR;
  
  for (prior in 1 : N_priors) {
    OR[prior] = exp(mu[prior]);
  }
}
