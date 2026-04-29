data {
  int<lower=3, upper=3> M; // Number of covariates
  int<lower=0> N; // Number of observations
  
  vector[M] x0;   // Covariate baselines
  matrix[N, M] X; // Covariate design matrix
}

transformed data {
  matrix[N, M] deltaX;
  vector[M] beta1_scale;
  vector[M] beta2_d_scale;
  vector[M * (M - 1) / 2] beta2_o_scale;
  
  for (n in 1:N) {
    deltaX[n,] = X[n] - x0';
  }
  
  beta1_scale[1] = 200 / 2.33;
  beta1_scale[2] = 20 / 2.33;
  beta1_scale[3] = 4 / 2.33;
  
  beta2_d_scale[1] = 20 / 2.33;
  beta2_d_scale[2] = 1 / 2.33;
  beta2_d_scale[3] = 0.016 / 2.33;
  
  beta2_o_scale[1] = 1 / 2.33;
  beta2_o_scale[2] = 0.4 / 2.33;
  beta2_o_scale[3] = 0.02 / 2.33;
}

parameters {
  real alpha;                      // Intercept
  vector[M] beta1;                 // Linear slopes
  vector[M] beta2_d;               // On-diagonal quadratic slopes
  vector[M * (M - 1) / 2] beta2_o; // Off-diagonal quadratic slopes
  real<lower=0> sigma;             // Measurement Variability
}

model {
  // Prior model
  alpha ~ normal(3000, 1000 / 2.33);
  beta1 ~ normal(0, beta1_scale);
  beta2_d ~ normal(0, beta2_d_scale);
  beta2_o ~ normal(0, beta2_o_scale);
  sigma ~ normal(0, 500);
}

generated quantities {
  vector[N] mu = alpha + deltaX * beta1;
  {
    matrix[M, M] beta2;
    for (m1 in 1:M) {
      beta2[m1, m1] = beta2_d[m1];
      for (m2 in (m1 + 1):M) {
        int m3 = (2 * M - m1) * (m1 - 1) / 2 + m2 - m1;
        beta2[m1, m2] = beta2_o[m3];
        beta2[m2, m1] = beta2_o[m3];
      }
    }
    
    for (n in 1:N) {
      mu[n] = mu[n] + deltaX[n] * beta2 * deltaX[n]';
    }
  }
}
