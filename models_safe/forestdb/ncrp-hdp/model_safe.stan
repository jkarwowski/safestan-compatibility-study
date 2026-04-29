// ForestDB translation: Nested CRP + HDP
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
  local_weight ~ dirichlet(5 * global_weight);
  atom ~ dirichlet(rep_vector(1.0, V));

  {
    array[N] vector[V] y_prob;
    for (n in 1:N) {
      y_prob[n] = rep_vector(0.0, V);
      for (k in 1:K) {
        y_prob[n] += local_weight[doc[n]][k] * atom[k];
      }
    }
    y ~ categorical(y_prob);
  }
}
generated quantities {
  array[D] int<lower=1, upper=K> group_cluster;
  for (d in 1:D) {
    group_cluster[d] = categorical_rng(local_weight[d]);
  }
}
