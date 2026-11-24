data {
  int N;
  array[N] int y;
  array[N] int compania;
  real<lower=0> gamma_alpha;
  real<lower=0> gamma_beta;
}

parameters {
  array[6] real log_lambda;
  array[6] real<lower=0> phi; 
}

model {
  log_lambda ~ normal(4, 0.5);
  phi    ~ gamma(gamma_alpha, gamma_beta); 
  y      ~ neg_binomial_2_log(log_lambda[compania], phi[compania]);
}

generated quantities {
  array[6] int y_tilde;
  for (ii in 1:6){
    y_tilde[ii] = neg_binomial_2_log_rng(log_lambda[ii], phi[ii]);
  }
}
