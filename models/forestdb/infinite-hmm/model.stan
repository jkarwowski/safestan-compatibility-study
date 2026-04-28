// ForestDB translation: Infinite Hidden Markov Model
data {
  int<lower=1> D;
  int<lower=1> K;
  int<lower=1> V;
  int<lower=1> N;
  array[N] int<lower=1, upper=D> doc;
  array[N] int<lower=1, upper=V> y;
}
parameters {
  simplex[K] global_weight;
  array[D] simplex[K] local_weight;
  array[K] simplex[V] atom;
}
model {
  global_weight ~ dirichlet(rep_vector(1.0, K));
  for (d in 1:D) {
    local_weight[d] ~ dirichlet(5 * global_weight);
  }
  for (k in 1:K) {
    atom[k] ~ dirichlet(rep_vector(1.0, V));
  }
  for (n in 1:N) {
    vector[K] lp;
    for (k in 1:K) {
      lp[k] = log(local_weight[doc[n], k]) + log(atom[k, y[n]]);
    }
    target += log_sum_exp(lp);
  }
}
generated quantities {
  array[D] int<lower=1, upper=K> group_cluster;
  for (d in 1:D) {
    group_cluster[d] = categorical_rng(local_weight[d]);
  }
}
