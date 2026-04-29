// Evan Ira Blumgart (2012) Hamiltonian Monte Carlo Estimation of
// PM2.5 Source Apportionment and Related Health Effects.
// M.A. Dissertation.  Department of Statistics.
// The University of Auckland.

data {
  int<lower=0> T;
  int<lower=0> I;
  int<lower=0> K;
  matrix<lower=0.0>[T, I] X;
  matrix<lower=0.0>[T, I] X_safestan_copy;
  array[I] real<lower=0> sigma;
}
transformed data {
  real<lower=0> g_bar;
  real<lower=0> g_sigma;
  vector[T] temp;
  matrix[T, I] sigma_matrix;

  for (t in 1 : T) {
    temp[t] = log(sum(X_safestan_copy[t]));
    for (i in 1 : I) {
      sigma_matrix[t, i] = sigma[i];
    }
  }
  g_bar = mean(temp);
  g_sigma = sd(temp);
}
parameters {
  matrix<lower=0>[T, K] G;
  array[K] simplex[I] F;
}
model {
  matrix[K, I] F_matrix;
  matrix[T, I] mu;

  G ~ lognormal(g_bar, g_sigma);
  F ~ dirichlet(rep_vector(1.0, I));

  for (k in 1 : K) {
    F_matrix[k] = to_row_vector(F[k]);
  }
  mu = G * F_matrix;

  X ~ normal(mu, sigma_matrix);
}
