data {
  int<lower=3, upper=3> M; // Number of covariates
  int<lower=0> N; // Number of observations

  vector[M] x0;   // Covariate baselines
  matrix[N, M] X; // Covariate design matrix

  array[N] real y;      // Variates
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
  real<lower=0> sigma; // Measurement Variability
}

model {
  // Prior model
  alpha ~ normal(3000, 1000 / 2.33);
  beta ~ normal([0, 0, 0]', [200 / 2.33, 20 / 2.33, 4 / 2.33]');
  sigma ~ normal(0, 500);

  // Vectorized observation model
  y ~ normal(alpha + deltaX * beta, sigma);
}

// Simulate a full observation from the current value of the parameters
generated quantities {
  array[N] real y_pred = normal_rng(alpha + deltaX * beta, sigma);
}
