

data {
  int<lower=0> N;
  int<lower=0> nCov;
  matrix[N,nCov] X;
  array[N] int<lower=0> y;
  array[2] real prior_ln_lambda;
}

parameters {
  vector[nCov] beta;
  vector[N] ln_lambda;
}

model {
  beta ~ normal(0, 1);
  ln_lambda ~ normal(prior_ln_lambda[1], prior_ln_lambda[2]);
  
  y ~ poisson_log_glm(X, ln_lambda, beta);
}

generated quantities {
  array[N] int<lower=0> y_pred;
  vector[N] log_lik;
  
  for(i in 1:N) {
    y_pred[i] = poisson_log_rng(ln_lambda[i] + X[i,] * beta);
    log_lik[i] = poisson_log_lpmf(y[i] | ln_lambda[i] + X[i,] * beta);
  }
}

