// Orange Trees (Multi-variate normal) 
// http://www.openbugs.net/Examples/OtreesMVN.html
// and refer to ../orange 

// FIXME: there are some discrepancy for parameters var 
// and the s.e. for some parameters

data {
  int<lower=0> K;
  int<lower=0> N;
  array[N] int x;
  vector[K * N] Y_safestan_flat;
  cov_matrix[3] invR;
  cov_matrix[3] mu_var_prior;
  vector[3] mu_m_prior;
}
parameters {
  real<lower=0> sigmasq;
  array[K] vector[3] theta;
  vector[3] mu;
  cov_matrix[3] sigma2;
}
transformed parameters {
  real<lower=0> sigma_C;
  sigma_C = sqrt(sigmasq);
}
model {
  array[K, 3] real phi;
  vector[K * N] y_mean_flat;
  
  sigmasq ~ inv_gamma(.001, .001);
  mu ~ multi_normal(mu_m_prior, mu_var_prior);
  sigma2 ~ inv_wishart(3, invR);
  theta ~ multi_normal(mu, sigma2);
  
  for (k in 1 : K) {
    phi[k, 1] = exp(theta[k, 1]);
    phi[k, 2] = exp(theta[k, 2]) - 1;
    phi[k, 3] = -exp(theta[k, 3]);
    for (n in 1 : N) {
      y_mean_flat[(k - 1) * N + n] = phi[k, 1] / (1 + phi[k, 2] * exp(phi[k, 3] * x[n]));
    }
  }
  
  Y_safestan_flat ~ normal(y_mean_flat, sigma_C);
}
generated quantities {
  vector[3] sigma;
  sigma[1] = sqrt(sigma2[1, 1]);
  sigma[2] = sqrt(sigma2[2, 2]);
  sigma[3] = sqrt(sigma2[3, 3]);
}
