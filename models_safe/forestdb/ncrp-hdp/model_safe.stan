// ForestDB translation: Nested CRP + HDP
// SafeStan rewrite: observations aggregated into protected document-symbol counts.
data {
  int<lower=1> D;
  int<lower=1> K;
  int<lower=1> V;
  array[V] int<lower=0> y_counts_1;
  array[V] int<lower=0> y_counts_2;
  array[V] int<lower=0> y_counts_3;
  array[V] int<lower=0> y_counts_4;
  array[V] int<lower=0> y_counts_5;
}
parameters {
  simplex[K] global_weight;
  array[D] simplex[K] local_weight;
  array[K] simplex[V] atom;
}
model {
  vector[V] y_prob_1 = rep_vector(0.0, V);
  vector[V] y_prob_2 = rep_vector(0.0, V);
  vector[V] y_prob_3 = rep_vector(0.0, V);
  vector[V] y_prob_4 = rep_vector(0.0, V);
  vector[V] y_prob_5 = rep_vector(0.0, V);

  global_weight ~ dirichlet(rep_vector(1.0, K));
  local_weight ~ dirichlet(5 * global_weight);
  atom ~ dirichlet(rep_vector(1.0, V));

  for (k in 1:K) {
    y_prob_1 += local_weight[1, k] * atom[k];
    y_prob_2 += local_weight[2, k] * atom[k];
    y_prob_3 += local_weight[3, k] * atom[k];
    y_prob_4 += local_weight[4, k] * atom[k];
    y_prob_5 += local_weight[5, k] * atom[k];
  }
  y_counts_1 ~ multinomial(y_prob_1);
  y_counts_2 ~ multinomial(y_prob_2);
  y_counts_3 ~ multinomial(y_prob_3);
  y_counts_4 ~ multinomial(y_prob_4);
  y_counts_5 ~ multinomial(y_prob_5);
}
generated quantities {
  array[D] int<lower=1, upper=K> group_cluster;
  for (d in 1:D) {
    group_cluster[d] = categorical_rng(local_weight[d]);
  }
}
