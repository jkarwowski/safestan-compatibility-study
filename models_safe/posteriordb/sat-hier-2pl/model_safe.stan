data {
  int<lower=1> I; // // items
  int<lower=1> J; // // persons
  int<lower=1> N; // // observations
  array[N] int<lower=1, upper=I> ii; // item for n
  array[N] int<lower=1, upper=J> jj; // person for n
  array[N] int<lower=0, upper=1> y; // correctness for n
}
parameters {
  vector[J] theta; // abilities
  array[I] vector[2] xi; // alpha/beta pair vectors
  vector[2] mu; // vector for alpha/beta means
  vector<lower=0>[2] tau; // vector for alpha/beta residual sds
  cholesky_factor_corr[2] L_Omega;
}
transformed parameters {
  vector[I] xi1;
  vector[I] xi2;
  vector[I] alpha;
  vector[I] beta;
  for (i in 1 : I) {
    xi1[i] = xi[i, 1];
    xi2[i] = xi[i, 2];
    alpha[i] = exp(xi[i, 1]);
    beta[i] = xi[i, 2];
  }
}
model {
  matrix[2, 2] L_Sigma;
  theta ~ normal(0, 1);
  L_Omega ~ lkj_corr_cholesky(4);
  mu ~ normal(rep_vector(0, 2), [1, 5]');
  tau ~ exponential(.1);
  L_Sigma = diag_pre_multiply(tau, L_Omega);
  xi ~ multi_normal_cholesky(mu, L_Sigma);
  y ~ bernoulli_logit(alpha[ii] .* (theta[jj] - beta[ii]));
}
generated quantities {
  corr_matrix[2] Omega;
  Omega = multiply_lower_tri_self_transpose(L_Omega);
}
