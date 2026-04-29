data {
  int<lower=1> K; // num categories
  int<lower=1> V; // num words
  int<lower=0> T; // num instances
  int<lower=0, upper=T> Tm1; // max(T - 1, 0)
  array[T] int<lower=1, upper=V> w; // words
  array[T] int<lower=1, upper=K> z; // categories, retained as context
  array[Tm1] int<lower=1, upper=K> z_tail; // deterministic copy of z[2:T]
  vector<lower=0>[K] alpha; // transit prior
  vector<lower=0>[V] beta; // emit prior
}
transformed data {
  matrix[T, K] X_w = rep_matrix(0, T, K);
  matrix[Tm1, K] X_z = rep_matrix(0, Tm1, K);
  vector[V] zero_w_logits = rep_vector(0, V);
  vector[K] zero_z_logits = rep_vector(0, K);

  for (t in 1 : T) {
    X_w[t, z[t]] = 1;
  }
  for (t in 1 : Tm1) {
    X_z[t, z[t]] = 1;
  }
}
parameters {
  array[K] simplex[K] theta; // transit probs
  array[K] simplex[V] phi; // emit probs
}
transformed parameters {
  matrix[K, K] log_theta;
  matrix[K, V] log_phi;

  for (k in 1 : K) {
    for (j in 1 : K) {
      log_theta[k, j] = log(theta[k, j]);
    }
  }
  for (k in 1 : K) {
    for (v in 1 : V) {
      log_phi[k, v] = log(phi[k, v]);
    }
  }
}
model {
  theta ~ dirichlet(alpha);
  phi ~ dirichlet(beta);
  z_tail ~ categorical_logit_glm(X_z, zero_z_logits, log_theta);
  w ~ categorical_logit_glm(X_w, zero_w_logits, log_phi);
}
