functions {
  array[] int make_slice_index(array[] int S) {
    array[size(S)+1] int Si;
    int cv = 1;
    Si[1] = cv;
    for(i in 1:size(S)) {
      cv = cv + S[i];
      Si[i+1] = cv;
    }
    return(Si);
  }

  real log_diff_exp_abs(real la, real lb) {
    return(0.5 * log_diff_exp(log_sum_exp(2*la, 2*lb), log(2) + la + lb));
  }

  vector pk_1cmt_oral(vector tad, real ldose, real lka, real lCL, real lV) {
    real lk = lCL - lV;
    real k = exp(lk);
    real ka = exp(lka);
    real lkdelta = log_diff_exp_abs(lka, lk);
    real lscale = ldose - lV + lka - lkdelta;
    int N = num_elements(tad);
    vector[N] pk;

    for(i in 1:N) {
      pk[i] = lscale + log_diff_exp_abs(-k * tad[i], -ka * tad[i]);
    }

    return(pk);
  }

  vector pk_1cmt_oral_tlagMax(vector tad, real ldose, real llag, real lka, real lCL, real lV) {
    real lag = exp(llag);
    return pk_1cmt_oral(tad - lag, ldose, lka, lCL, lV);
  }
}
data {
  int J;
  real<lower=0> tlag_max;
  vector<lower=0>[J] dose;
  array[J] int N;
  vector<lower=0>[sum(N)] dv;
  vector<lower=tlag_max>[sum(N)] time;
  vector<lower=0>[J] weight;
  real<lower=0> ref;
}
transformed data {
  int Ndv = sum(N);
  row_vector[J] LSweight = to_row_vector(log(weight) - log(70.));
  vector[J] ldose = log(dose);
  real ltlag_max = log(tlag_max);
  array[J+1] int sidx = make_slice_index(N);
  real refSq = square(ref);
  vector[4] theta_prior_mean;
  vector[4] theta_prior_sd;

  theta_prior_mean[1] = 0;
  theta_prior_mean[2] = log(1);
  theta_prior_mean[3] = log(0.1);
  theta_prior_mean[4] = log(10);

  theta_prior_sd[1] = 2;
  theta_prior_sd[2] = log(2) / 1.96;
  theta_prior_sd[3] = log(10) / 1.96;
  theta_prior_sd[4] = log(10) / 1.96;
}
parameters {
  vector[4] theta;
  vector[4 * J] Eta_vec;
  vector<lower=0>[4] sigma_eta;
  real<lower=0> sigma_y;
  real<lower=0> kappa;
}
transformed parameters {
  vector[Ndv] mu;
  matrix[4,J] Eta;
  matrix[4,J] Eta_cov;

  Eta = to_matrix(Eta_vec, 4, J);

  Eta_cov[1] = log_inv_logit(theta[1] + sigma_eta[1] * Eta[1]) + ltlag_max;
  Eta_cov[2] = theta[2] + sigma_eta[2] * Eta[2];
  Eta_cov[3] = theta[3] + sigma_eta[3] * Eta[3] + 0.75 * LSweight;
  Eta_cov[4] = theta[4] + sigma_eta[4] * Eta[4] + LSweight;

  for(j in 1:J) {
    int start = sidx[j];
    int end = sidx[j+1]-1;
    mu[start:end] = exp(pk_1cmt_oral_tlagMax(time[start:end], ldose[j], Eta_cov[1,j], Eta_cov[2,j], Eta_cov[3,j], Eta_cov[4,j])) + 1E-5;
  }
}
model {
  vector[Ndv] muSq;
  vector[Ndv] sigmaSq;

  theta ~ normal(theta_prior_mean, theta_prior_sd);
  sigma_eta ~ normal(0, 0.5);
  Eta_vec ~ normal(0, 1);
  sigma_y ~ normal(0, 2);
  kappa ~ gamma(0.2, 0.2);

  muSq = square(mu);
  sigmaSq = square(sigma_y) + muSq / (kappa * refSq);
  dv ~ gamma(muSq ./ sigmaSq, mu ./ sigmaSq);
}
generated quantities {
  real tlag = inv_logit(theta[1]) * tlag_max;
  real ka = exp(theta[2]);
  real CL = exp(theta[3]);
  real V = exp(theta[4]);
  vector[Ndv] log_lik;
  vector[Ndv] ypred;
  vector[Ndv] ypred_cond;
  vector[J] log_lik_patient;
  real sigma_y_ref = sqrt(square(sigma_y) + 1.0/kappa);
  vector[Ndv] muSq = square(mu);
  vector[Ndv] sigmaSq = square(sigma_y) + muSq / (kappa * refSq);
  vector[Ndv] gamma_shape = muSq ./ sigmaSq;
  vector[Ndv] gamma_rate = mu ./ sigmaSq;

  for(o in 1:Ndv) {
    log_lik[o] = gamma_lpdf(dv[o] | gamma_shape[o], gamma_rate[o]);
    ypred_cond[o] = gamma_rng(gamma_shape[o], gamma_rate[o]);
  }

  for(j in 1:J) {
    int start = sidx[j];
    int end = sidx[j+1]-1;
    vector[4] eta = multi_normal_cholesky_rng(theta, diag_matrix(sigma_eta));
    vector[4] eta_cov;
    vector[N[j]] mu_pred;
    vector[N[j]] muSq_pred;
    vector[N[j]] sigmaSq_pred;
    vector[N[j]] gamma_shape_pred;
    vector[N[j]] gamma_rate_pred;

    eta_cov[1] = log_inv_logit(eta[1]) + ltlag_max;
    eta_cov[2] = eta[2];
    eta_cov[3] = eta[3] + 0.75 * LSweight[j];
    eta_cov[4] = eta[4] + LSweight[j];

    mu_pred = exp(pk_1cmt_oral_tlagMax(time[start:end], ldose[j], eta_cov[1], eta_cov[2], eta_cov[3], eta_cov[4])) + 1E-5;
    muSq_pred = square(mu_pred);
    sigmaSq_pred = square(sigma_y) + muSq_pred / (kappa * refSq);
    gamma_shape_pred = muSq_pred ./ sigmaSq_pred;
    gamma_rate_pred = mu_pred ./ sigmaSq_pred;

    log_lik_patient[j] = gamma_lpdf(dv[start:end] | gamma_shape_pred, gamma_rate_pred);
    for(k in 1:N[j]) {
      ypred[start + k - 1] = gamma_rng(gamma_shape_pred[k], gamma_rate_pred[k]);
    }
  }
}
