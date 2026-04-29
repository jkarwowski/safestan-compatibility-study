data {
  int<lower=0> M; // Number of covariates
  int<lower=0> N; // Number of observations

  vector[M] x0;   // Covariate baselines
  matrix[N, M] X; // Covariate design matrix
}

transformed data {
  matrix[N, M] deltaX;
  for (n in 1:N) {
    deltaX[n,] = X[n] - x0';
  }
}

parameters {
  real alpha;      // Intercept
  vector[M] beta;  // Linear slopes
}

transformed parameters {
  vector<lower=0, upper=1>[N] p = alpha + deltaX * beta;
}

model {
  // Prior model
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
}

// Simulate a full observation from the current value of the parameters
generated quantities {
  array[N] int y_pred = bernoulli_rng(p);
}
