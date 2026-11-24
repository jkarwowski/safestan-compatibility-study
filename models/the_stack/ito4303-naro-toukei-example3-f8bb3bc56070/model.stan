data {
  int<lower = 0> N;            // Number of data records
  int<lower = 0> M;            // Number of blocks
  int<lower = 1> L;            // Number of coefficients
  array[N] row_vector[L] X;          // Data
  array[N] real Y;
  array[N] int<lower = 1, upper = M> B; // Block
}

parameters {
  array[M] real e;                   // Random effect
  vector[L] beta;
  array[2] real<lower = 0> sigma;
}

transformed parameters {
  vector[N] mu;

  // Mean values
  for (i in 1:N)
    mu[i] = X[i] * beta + e[B[i]];
}

model {
  // Improper uniform priors are implicitly defined on beta and sigma.

  // Vectorized
  Y ~ normal(mu, sigma[1]);
  e ~ normal(0, sigma[2]);
}
