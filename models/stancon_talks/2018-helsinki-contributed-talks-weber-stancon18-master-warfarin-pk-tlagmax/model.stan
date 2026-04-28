functions {
// Begin expanded include: utils.stan
/**
 * turn a slicing variable for a ragged array
 * S = {5, 6, 11}
 * into
 * Si = {0, 5, 5 + 6, 5+6+11} + 1
 * such that we can index the ragged array A as
 * A[Si[u] : Si[u+1]-1]
 * for the uth unit
 */
int[] make_slice_index(int[] S) {
  int Si[size(S)+1];
  int cv = 1;
  Si[1] = cv;
  for(i in 1:size(S)) {
    cv = cv + S[i];
    Si[i+1] = cv;
  }
  return(Si);
}

/**
 * calculate the absolute value of a - b in log-space with log(a)
 * and log(b) given. Does so by squaring and taking the root, i.e.
 *   la = log(a)
 *   lb = log(b)
 * sqrt( (a - b)^2 ) = sqrt( a^2 - 2 * a * b + b^2 )
 * <=> 0.5 * log_diff_exp(log_sum_exp(2*la, 2*lb), log(2) + la + lb)
 */
real log_diff_exp_abs(real la, real lb) {
  return(0.5 * log_diff_exp(log_sum_exp(2*la, 2*lb), log(2) + la + lb));
}
// End expanded include: utils.stan
// Begin expanded include: gamma2_overdisp.stan

real gamma2_overdisp_lpdf(vector y, vector mu, real sigma, real kappa) {
  int N = rows(y);
  vector[N] muSq = square(mu);
  vector[N] sigmaSq = square(sigma) + muSq / kappa;
  return gamma_lpdf(y| muSq ./ sigmaSq, mu ./ sigmaSq);
}

real gamma2_overdisp_array_lpdf(real[] y, vector mu, real sigma, real kappa) {
  int N = size(y);
  vector[N] muSq = square(mu);
  vector[N] sigmaSq = square(sigma) + muSq / kappa;
  return gamma_lpdf(y| muSq ./ sigmaSq, mu ./ sigmaSq);
}

real gamma2_overdisp_cdf(real y, real mu, real sigma, real kappa) {
  real muSq = square(mu);
  real sigmaSq = square(sigma) + muSq / kappa;
  return gamma_cdf(y, muSq ./ sigmaSq, mu ./ sigmaSq);
}

real gamma2_overdisp_rng(real mu, real sigma, real kappa) {
  real muSq = square(mu);
  real sigmaSq = square(sigma) + muSq / kappa;
  return gamma_rng(muSq ./ sigmaSq, mu ./ sigmaSq);
}
// End expanded include: gamma2_overdisp.stan
// Begin expanded include: models.stan
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

  // this version expects that the lag time is never greater than the
  // first tad time.
  vector pk_1cmt_oral_tlagMax(vector tad, real ldose, real llag, real lka, real lCL, real lV) {
    int k = 0;
    int N = num_elements(tad);
    real lag = exp(llag);
    vector[N] pk;

    if(lag > tad[1])
      reject("Tlag must not exceed first observation");
 
    return pk_1cmt_oral(tad - lag, ldose, lka, lCL, lV);
  }

// this version skips according to llag the first elements of tad
// (better use this if llag and tad is data only)
  vector pk_1cmt_oral_tlag(vector tad, real ldose, real llag, real lka, real lCL, real lV) {
    int k = 0;
    int N = num_elements(tad);
    real lag = exp(llag);
    vector[N] pk;
 
    // find out which elements have to be skipped due to lag
    while(tad[k+1] < lag && k+1 != N) {
      k = k + 1;
      pk[k] = -25;
    }

    pk[k+1:N] = pk_1cmt_oral(tail(tad, N-k) - lag, ldose, lka, lCL, lV);
    return(pk);
  }

// work around the problem that we do not want things to land on the AD stack
  real pk_1cmt_oral_t(real tad, real ldose, real lka, real lCL, real lV) {
    real lk = lCL - lV;
    real k = exp(lk);
    real ka = exp(lka);
    real lkdelta = log_diff_exp_abs(lka, lk);
    real lscale = ldose - lV + lka - lkdelta;
    return lscale + log_diff_exp_abs(-k * tad, -ka * tad);
  }
  real pk_1cmt_oral_tlag_t(real t, real ldose, real llag, real lka, real lCL, real lV) {
    real lag = exp(llag);
    if (t < lag)
      return -25;
    return pk_1cmt_oral_t(t-lag , ldose, lka, lCL, lV);
  }
// End expanded include: models.stan
}
data {
  int J;
  real<lower=0> tlag_max;
  vector<lower=0>[J] dose;
  int N[J];
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
  int sidx[J+1] = make_slice_index(N);
  real refSq = square(ref);
}
parameters {
  // log population parameters of 1-tlag, 2-ka, 3-Cl, 4-V
  vector[4] theta;

  // subject specific random effects
  matrix[4,J] Eta;
  vector<lower=0>[4] sigma_eta;

  real<lower=0> sigma_y;
  real<lower=0> kappa;
}
transformed parameters {
  vector[Ndv] mu;
  matrix[4,J] Eta_cov;

  // lag time is fitted as fraction in logit space relative to the
  // maximal tlag
  Eta_cov[1] = log_inv_logit(theta[1] + sigma_eta[1] * Eta[1]) + ltlag_max;
  Eta_cov[2] = theta[2] + sigma_eta[2] * Eta[2];
  // apply to CL and V the weight covariate effects
  Eta_cov[3] = theta[3] + sigma_eta[3] * Eta[3] +  0.75 * LSweight;
  Eta_cov[4] = theta[4] + sigma_eta[4] * Eta[4] +         LSweight;
  
  // loop over each subject and evaluate PK model
  for(j in 1:J) {
    int start = sidx[j];
    int end   = sidx[j+1]-1;
    mu[start:end] = exp(pk_1cmt_oral_tlagMax(time[start:end], ldose[j], Eta_cov[1,j], Eta_cov[2,j], Eta_cov[3,j], Eta_cov[4,j])) + 1E-5;
  }
}
model {
  theta[1] ~ normal(0, 2);
  theta[2] ~ normal(log(1),   log(2)/1.96);
  theta[3] ~ normal(log(0.1), log(10)/1.96);
  theta[4] ~ normal(log(10),  log(10)/1.96);

  sigma_eta ~ normal(0, 0.5);
 
  to_vector(Eta) ~ normal(0, 1);

  sigma_y ~ normal(0, 2);
  kappa ~ gamma(0.2, 0.2);

  dv ~ gamma2_overdisp(mu, sigma_y, kappa * refSq);
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

  for(o in 1:Ndv) {
    log_lik[o] = gamma2_overdisp_lpdf( dv[o:o] | mu[o:o], sigma_y, kappa * refSq);
    ypred_cond[o] = gamma2_overdisp_rng(mu[o], sigma_y, kappa * refSq);
  }

  for(j in 1:J) {
    int start = sidx[j];
    int end   = sidx[j+1]-1;
    vector[4] eta = multi_normal_cholesky_rng(theta, diag_matrix(sigma_eta));
    vector[4] eta_cov;
    vector[N[j]] mu_pred;

    eta_cov[1] = log_inv_logit(eta[1]) + ltlag_max;
    eta_cov[2] = eta[2];
    // apply to CL and V the weight covariate effects
    eta_cov[3] = eta[3] +  0.75 * LSweight[j];
    eta_cov[4] = eta[4] +         LSweight[j];

    mu_pred = exp(pk_1cmt_oral_tlagMax(time[start:end], ldose[j], eta_cov[1], eta_cov[2], eta_cov[3], eta_cov[4])) + 1E-5;

    log_lik_patient[j] = gamma2_overdisp_lpdf(dv[start:end]| mu_pred, sigma_y, kappa * refSq);
    for(k in 1:N[j]){
      ypred[start + k - 1] = gamma2_overdisp_rng(mu_pred[k], sigma_y, kappa * refSq);
    }
  }
}
