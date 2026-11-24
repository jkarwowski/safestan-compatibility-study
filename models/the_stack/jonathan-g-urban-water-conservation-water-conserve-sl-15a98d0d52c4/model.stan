data {
  int<lower=0> N; // # observations
  int<lower=0> K; // # predictors
  matrix[N,K] xx;  // predictors (real)
  array[N] int y;      // vwci
  int<lower=1> K_ACTIONS; // number of possible actions
}

parameters {
  real alpha;
  vector[K] beta;
}

model {
  vector[N] theta;

  alpha ~ cauchy(0,2.5);
  beta ~ cauchy(0,2.5);

  for(i in 1:N) {
    real mu;

    mu = alpha + xx[i,:] * beta;
    theta[i] = inv_logit(mu);
  }

  y ~ binomial(K_ACTIONS, theta);
}

generated quantities {
  vector[N] log_lik;
  array[N] int y_pred;

   for(i in 1:N) {
    real mu;
    real theta;

    mu = alpha + xx[i,:] * beta;
    theta = inv_logit(mu);

    log_lik[i] = binomial_lpmf(y[i] | K_ACTIONS, theta);
    y_pred[i] = binomial_rng(K_ACTIONS, theta);
  }
}
