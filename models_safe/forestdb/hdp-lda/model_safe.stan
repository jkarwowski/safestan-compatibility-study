// ForestDB translation: Latent Dirichlet Allocation with Hierarchical Dirichlet Prior
data {
  int<lower=1> D;
  int<lower=1> K;
  int<lower=1> V;
  int<lower=1> N;
  array[N] int<lower=1, upper=D> doc;
  array[N] int<lower=1, upper=V> y;
}
transformed data {
  matrix[N, D] doc_one_hot = rep_matrix(0.0, N, D);
  for (n in 1:N) {
    doc_one_hot[n, doc[n]] = 1.0;
  }
}
parameters {
  simplex[K] global_weight;
  array[D] simplex[K] local_weight;
  array[K] simplex[V] atom;
}
model {
  matrix[D, V] log_word_prob;

  global_weight ~ dirichlet(rep_vector(1.0, K));
  local_weight ~ dirichlet(5 * global_weight);
  atom ~ dirichlet(rep_vector(1.0, V));

  for (d in 1:D) {
    for (v in 1:V) {
      vector[K] component_lp;
      for (k in 1:K) {
        component_lp[k] = log(local_weight[d, k]) + log(atom[k, v]);
      }
      log_word_prob[d, v] = log_sum_exp(component_lp);
    }
  }

  y ~ categorical_logit_glm(doc_one_hot, rep_vector(0.0, V), log_word_prob);
}
generated quantities {
  array[D] int<lower=1, upper=K> group_cluster;
  for (d in 1:D) {
    group_cluster[d] = categorical_rng(local_weight[d]);
  }
}
