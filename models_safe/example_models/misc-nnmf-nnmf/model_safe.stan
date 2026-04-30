data {
  int<lower=0> T;
  int<lower=0> I;
  int<lower=0> K;
  matrix[T, I] X;
  matrix[T, I] X_safestan_copy;
  vector<lower=0>[T * I] X_safestan_flat;
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
  vector<lower=0>[T * K] G_raw;
  array[K] simplex[I] F; // implicit unif prior on simplexes
}
transformed parameters {
  matrix<lower=0>[T, K] G;
  for (t in 1 : T) {
    for (k in 1 : K) {
      G[t, k] = G_raw[(t - 1) * K + k];
    }
  }
}
model {
  G_raw ~ lognormal(g_bar, g_sigma);
  F ~ dirichlet(alpha);
  
  {
    matrix[K, I] F_matrix;
    matrix[T, I] mu;
    vector[T * I] mu_safestan_flat;
    vector[T * I] sigma_safestan_flat;
    for (k in 1 : K) {
      for (i in 1 : I) {
        F_matrix[k, i] = F[k, i];
      }
    }
    mu = G * F_matrix;
    for (t in 1 : T) {
      for (i in 1 : I) {
        mu_safestan_flat[(t - 1) * I + i] = mu[t, i];
        sigma_safestan_flat[(t - 1) * I + i] = sigma_matrix[t, i];
      }
    }
    X_safestan_flat ~ normal(mu_safestan_flat, sigma_safestan_flat) T[0, ];
  }
}
