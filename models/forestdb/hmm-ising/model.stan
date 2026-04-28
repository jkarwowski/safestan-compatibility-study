// ForestDB translation: HMM-Ising
data {
  int<lower=1> K;
  int<lower=1> V;
  int<lower=1> T;
  array[T] int<lower=1, upper=V> y;
}
parameters {
  simplex[K] initial;
  array[K] simplex[K] transition;
  array[K] simplex[V] emission;
}
model {
  array[T] vector[K] forward;

  initial ~ dirichlet(rep_vector(1.0, K));
  for (k in 1:K) {
    transition[k] ~ dirichlet(rep_vector(1.0, K));
    emission[k] ~ dirichlet(rep_vector(1.0, V));
  }

  for (k in 1:K) {
    forward[1, k] = log(initial[k]) + log(emission[k, y[1]]);
  }
  for (t in 2:T) {
    for (k in 1:K) {
      vector[K] acc;
      for (j in 1:K) {
        acc[j] = forward[t - 1, j] + log(transition[j, k]);
      }
      forward[t, k] = log(emission[k, y[t]]) + log_sum_exp(acc);
    }
  }
  target += log_sum_exp(forward[T]);
}
generated quantities {
  array[T] int<lower=1, upper=V> y_rep;
  int<lower=1, upper=K> z = categorical_rng(initial);
  for (t in 1:T) {
    y_rep[t] = categorical_rng(emission[z]);
    if (t < T) {
      z = categorical_rng(transition[z]);
    }
  }
}
