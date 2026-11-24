data {
  int<lower=0> n_dogs;
  int<lower=0> n_trials;
  int<lower=1> N_patterns;
  array[N_patterns] int<lower=1> dog_id;
  array[N_patterns] int<lower=0> prev_shock_count;
  array[N_patterns] int<lower=0> prev_avoid_count;
  array[N_patterns] int<lower=0> y_trials;
  array[N_patterns] int<lower=0> y_successes;
}
transformed data {
  int<lower=0> J = n_dogs;
  int<lower=0> T = n_trials;
}
parameters {
  vector[2] mu_logit_ab;
  vector<lower=0>[2] sigma_logit_ab;
  cholesky_factor_corr[2] L_logit_ab;
  vector[J * 2] z_vec;
}
transformed parameters {
  matrix[J, 2] z = to_matrix(z_vec, J, 2);
  matrix[J, 2] logit_ab = rep_vector(1, J) * mu_logit_ab'
                          + z * diag_pre_multiply(sigma_logit_ab, L_logit_ab);
  corr_matrix[2] Omega_logit_ab = L_logit_ab * L_logit_ab';
  cov_matrix[2] Sigma_logit_ab = quad_form_diag(Omega_logit_ab,
                                                sigma_logit_ab);
  vector[J] a = inv_logit(logit_ab[ : , 1]);
  vector[J] b = inv_logit(logit_ab[ : , 2]);
}
model {
  vector[N_patterns] p;

  mu_logit_ab ~ logistic(0, 1);
  sigma_logit_ab ~ normal(0, 1);
  L_logit_ab ~ lkj_corr_cholesky(2);
  z_vec ~ normal(0, 1);

  for (i in 1:N_patterns) {
    p[i] = a[dog_id[i]] ^ prev_shock_count[i]
           * b[dog_id[i]] ^ prev_avoid_count[i];
  }
  y_successes ~ binomial(y_trials, p);
}
generated quantities {
  array[J, T] int<lower=0, upper=1> y_rep;
  {
    real prev_shock_rep;
    real prev_avoid_rep;
    real p_rep;
    for (j in 1 : J) {
      prev_shock_rep = 0;
      prev_avoid_rep = 0;
      y_rep[j, 1] = 1;
      for (t in 2 : T) {
        prev_shock_rep = prev_shock_rep + y_rep[j, t - 1];
        prev_avoid_rep = prev_avoid_rep + 1 - y_rep[j, t - 1];
        p_rep = a[j] ^ prev_shock_rep * b[j] ^ prev_avoid_rep;
        y_rep[j, t] = bernoulli_rng(p_rep);
      }
    }
  }
}
