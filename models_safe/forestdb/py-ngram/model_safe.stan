// ForestDB translation: Pitman-Yor N-Gram
// SafeStan-compatible rewrite
// The finite mixture over atoms induces a categorical distribution over words.
data {
  int<lower=1> D;
  int<lower=1> K;
  int<lower=1> V;
  int<lower=1> N;
  array[N] int<lower=1, upper=D> doc;
  array[N] int<lower=1, upper=V> y;
}
transformed data {
  matrix[N, D] doc_onehot;
  doc_onehot = rep_matrix(0.0, N, D);
  for (n in 1:N) {
    doc_onehot[n, doc[n]] = 1.0;
  }
}
parameters {
  simplex[K] global_weight;
  array[D] simplex[K] local_weight;
  array[K] simplex[V] atom;
}
transformed parameters {
  matrix[D, V] log_doc_prob;
  for (d in 1:D) {
    vector[V] probs;
    probs = rep_vector(0.0, V);
    for (k in 1:K) {
      probs += local_weight[d, k] * atom[k];
    }
    log_doc_prob[d] = log(probs)';
  }
}
model {
  global_weight ~ dirichlet(rep_vector(1.0, K));
  local_weight ~ dirichlet(5 * global_weight);
  atom ~ dirichlet(rep_vector(1.0, V));
  y ~ categorical_logit_glm(doc_onehot, rep_vector(0.0, V), log_doc_prob);
}
generated quantities {
  array[D] int<lower=1, upper=K> group_cluster;
  for (d in 1:D) {
    group_cluster[d] = categorical_rng(local_weight[d]);
  }
}
