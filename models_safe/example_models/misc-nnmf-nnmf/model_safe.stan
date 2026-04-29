data {
  int<lower=0> T;
  int<lower=0> I;
  int<lower=0> K;
  matrix[T, I] X;
  matrix[T, I] X_safestan_copy;
  array[I] real<lower=0> sigma;
}
transformed data {
  real<lower=0> g_bar;
  real<lower=0> g_sigma;
  vector<lower=0>[I] alpha;
  vector[T] temp;
  matrix[T, I] sigma_matrix;
  for (t in 1 : T) {
    temp[t] = log(sum(X_safestan_copy[t]));
  }
  g_bar = mean(temp);
  g_sigma = sd(temp);
  for (i in 1 : I) {
    alpha[i] = 10.0;
    for (t in 1 : T) {
      sigma_matrix[t, i] = sigma[i];
    }
  }
}
parameters {
  matrix<lower=0>[T, K] G;
  array[K] simplex[I] F; // implicit unif prior on simplexes
}
model {
  G ~ lognormal(g_bar, g_sigma);
  F ~ dirichlet(alpha);
  
  {
    matrix[K, I] F_matrix;
    matrix[T, I] mu;
    for (k in 1 : K) {
      for (i in 1 : I) {
        F_matrix[k, i] = F[k, i];
      }
    }
    mu = G * F_matrix;
    X ~ normal(mu, sigma_matrix) T[0, ];
  }
}
