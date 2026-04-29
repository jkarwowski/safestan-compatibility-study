functions {
  /**
   * turn a slicing variable for a ragged array
   * S = {5, 6, 11}
   * into
   * Si = {0, 5, 5 + 6, 5+6+11} + 1
   * such that we can index the ragged array A as
   * A[Si[u] : Si[u+1]-1]
   * for the uth unit
   */
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
}
data {
  int<lower=1> J;
  vector<lower=0>[J] dose;
  array[J] int<lower=1> N;
  vector[sum(N)] dv;
  array[sum(N)] real<lower=0> time;
  matrix[4,J] Eta_est;
  real<lower=0> ref;
}
transformed data {
  int Ndv = sum(N);
  array[J+1] int sidx = make_slice_index(N);
  array[J, 3] int x_i;
  array[J, 6 + 2*Ndv] real x_r;
  real t0 = -1E-4;
  real refSq = square(ref);
  vector[3] zero = rep_vector(0.0, 3);
  matrix[3,3] Identity = diag_matrix(rep_vector(1.0,3));
  vector[3] theta_prior_mean = [log(80), log(30), log(2.5)]';

  for(j in 1:J) {
    x_r[j,1] = log(dose[j]);
    x_r[j,2:5] = to_array_1d(Eta_est[:,j]);
    x_r[j,6] = refSq;
    x_r[j,7:7+Ndv-1] = to_array_1d(time);
    x_r[j,7+Ndv:7+2*Ndv-1] = to_array_1d(dv);

    x_i[j,1] = sidx[j];
    x_i[j,2] = sidx[j+1];
    x_i[j,3] = Ndv;
  }
}
parameters {
  // log for 1-R0=kin/kout, 2-1/kout, 3-EC50
  vector[3] theta;

  //matrix[3,J] Eta;
  array[J] vector[3] Eta;
  vector<lower=0>[3]  sigma_eta;

  real<lower=0> sigma_y;
  real<lower=0> kappa;
}
transformed parameters {
}
model {
  theta ~ normal(theta_prior_mean, log(10) / 1.96);

  sigma_eta ~ normal(0, 0.5);
  kappa ~ gamma(0.2, 0.2);

  Eta ~ multi_normal_cholesky(zero, Identity);

  sigma_y ~ normal(0, 10);
}
generated quantities {
  real R0 = exp(theta[1]);
  real kin = exp(theta[1] - theta[2]);
  real kout = exp(-theta[2]);
  real EC50 = exp(theta[3]);
  real sigma_y_ref = sqrt(square(sigma_y) + 1.0/kappa);
}
