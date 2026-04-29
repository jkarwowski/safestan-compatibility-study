data {
  int<lower=3, upper=3> M; // Number of covariates
  int<lower=0> N; // Number of observations
  
  vector[M] x0;   // Covariate baselines
  matrix[N, M] X; // Covariate design matrix
}

transformed data {
  matrix[N, M] deltaX;
  vector[M] beta_scale;

  beta_scale[1] = 200 / 2.33;
  beta_scale[2] = 20 / 2.33;
  beta_scale[3] = 4 / 2.33;

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
  beta ~ normal(0, beta_scale);
  sigma ~ normal(0, 500);
}

// Simulate a full observation from the current value of the parameters
generated quantities {
  vector[N] mu = alpha + deltaX * beta;
}
