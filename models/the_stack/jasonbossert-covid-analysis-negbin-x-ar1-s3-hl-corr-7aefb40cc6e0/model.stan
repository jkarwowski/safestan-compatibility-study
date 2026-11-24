functions {
  /**
  *
  *
  *
  */
  int num_zero_ts(array[,] int ts) {
    int N = dims(ts)[1];
    int Nz = 0;

    for (n in 1:N) {
      if (sum(ts[n, :]) == 0) {
        Nz = Nz + 1;
      }
    }
    return Nz;
  }

  /**
  *
  *
  *
  */
  array[] int idxs_zero_ts(array[,] int ts) {
    int N = dims(ts)[1];
    int Nz = num_zero_ts(ts);

    array[Nz] int idxs = rep_array(0, Nz);
    int idx = 1;
    for (n in 1:N) {
      if (sum(ts[n, :]) == 0) {
        idxs[idx] = n;
        idx = idx + 1;
      }
    }
    return idxs;
  }
}

data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=0> K;
  array[N, T] int<lower=0> y;

  array[N] matrix<lower=0>[T, K] X;

  vector[1 + 4 + K] mu_betas_center;
  vector<lower=0>[1 + 4 + K] mu_betas_scale;

  vector<lower=0>[1 + 4 + K] tau_betas_center;
  vector<lower=0>[1 + 4 + K] tau_betas_scale;

  real inv_phi_alpha;
  real inv_phi_beta;
}

transformed data {
  int Nz = num_zero_ts(y);
  array[Nz] int z_idxs = idxs_zero_ts(y);

  int P = 4;
  int<lower=0> lags = 7;
  array[lags] int<lower=1> Ps = {1, 7, 8, 14, 15, 21, 22};

  array[N] matrix<lower=0>[T, 1 + lags + K] L = rep_array(rep_matrix(0, T, 1 + lags + K), N);

  L[:, :, 1] = rep_array(rep_vector(1, T), N);
  for (n in 1:N) {
    L[n, :, (lags+2):] = log(X[n] + 1.001);
  }
  
  for (n in 1:N) {
    for (p in 1:lags) {
      int lag = Ps[p];
      L[n, lag+1:, p + 1] = log(to_vector(y[n, :T-lag]) + 1.001);
    }
  }
}

parameters {
  real<lower=0> inv_eta;
  array[N] real<lower=0> inv_phi;

  matrix[N, 1 + P + K] raw_betas;

  vector[1 + P + K] mu_betas;
  vector<lower=0>[1 + P + K] tau_betas;
  corr_matrix[1 + P + K] Omega_betas;
}

transformed parameters {
  real eta = 1.0 /inv_eta;
  array[N] vector[T] nu;
  array[N] real phi;

  matrix[N, 1 + P + K] betas;
  matrix[N, 1 + lags + K] betas_expanded;

  // Noncentered Parameterization
  for (n in 1:N) {
    betas[n, :] = mu_betas' + raw_betas[n, :] * quad_form_diag(Omega_betas, tau_betas);
  }

  // Dispersion
  for (n in 1:N) {
    phi[n] = 1.0 / inv_phi[n];
  } 

  // Set degenerate parameters to zero
  betas[z_idxs, 2:(P+1)] = rep_matrix(0, Nz, P);

  // Expand Parameters to allow for AR 
  betas_expanded[:, 1] = betas[:, 1];  // Intercept
  betas_expanded[:, (lags+2):] = betas[:, (P+2):];  // Covariate Regression

  betas_expanded[:, 2:(lags+1)] = [betas[:, 2]', 
                                   betas[:, 3]', 
                                   (-1 * betas[:, 2] .* betas[:, 3])', 
                                   betas[:, 4]', 
                                   (-1 * betas[:, 2] .* betas[:, 4])', 
                                   betas[:, 5]', 
                                   (-1 * betas[:, 2] .* betas[:, 5])']';
  

  // Calculate nu
  for (n in 1:N) {
    nu[n] = L[n] * betas_expanded[n]';
  }
}

model {
  // Regular Priors
  inv_phi ~ gamma(inv_phi_alpha, inv_phi_beta);

  // Center Parameterization Priors
  to_vector(raw_betas) ~ normal(0, 1);

  // Heirarchical Priors
  mu_betas ~ normal(mu_betas_center, mu_betas_scale);
  tau_betas ~ normal(tau_betas_center, tau_betas_scale);

  inv_eta ~ normal(0, .3);
  Omega_betas ~ lkj_corr(eta);

  // Liklihood
  for (n in 1:N) {
    y[n] ~ neg_binomial_2_log(nu[n], phi[n]);
  }
}

generated quantities {
  array[N, T] real y_pred;
  array[N, T] real log_lik;

  for (n in 1:N) { 
    for (t in 1:T) {
      log_lik[n, t] = neg_binomial_2_log_lpmf(y[n, t] | nu[n, t], phi[n]);
    }

    for (t in 1:T) {
      if (nu[n, t] < 15 && nu[n, t] > -15) 
        y_pred[n, t] = neg_binomial_2_log_rng(nu[n, t], phi[n]);
      else if (nu[n, t] > 15)
        y_pred[n, t] = neg_binomial_2_log_rng(15,  phi[n]);
      else
        y_pred[n, t] = neg_binomial_2_log_rng(-15, phi[n]);
    }
  }
}
