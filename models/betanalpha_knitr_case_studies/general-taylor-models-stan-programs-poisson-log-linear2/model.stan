data {
  int<lower=0> M; // Number of covariates
  int<lower=0> N; // Number of observations

  vector[M] x0;   // Covariate baselines
  matrix[N, M] X; // Covariate design matrix

  array[N] int y;       // Variates
}

transformed data {
  matrix[N, M] deltaX;
  for (n in 1:N) {
    deltaX[n,] = X[n] - x0';
  }
}

parameters {
  real alpha;          // Intercept
  vector[M] beta;      // Slopes
}

model {
  // Prior model
  alpha ~ normal(3, 0.2);
  beta ~ normal(0, log(1.28));

  // Vectorized observation model
  y ~ poisson_log(alpha + deltaX * beta);
}

// Simulate a full observation from the current value of the parameters
generated quantities {
  vector[N] mu = exp(alpha + deltaX * beta);
  array[N] int y_pred = poisson_log_rng(alpha + deltaX * beta);
}
