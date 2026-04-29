// ForestDB translation: Citation Matching
// SafeStan-compatible rewrite
// The Bernoulli mixture likelihood is collapsed algebraically:
//   sum_k w[k] Bernoulli(y | p[k]) = Bernoulli(y | dot_product(w, p)).
data {
  int<lower=1> K;
  int<lower=1> N;
  array[N] int<lower=0, upper=1> y;
}
parameters {
  simplex[K] cluster_weight;
  vector<lower=0, upper=1>[K] cluster_prob;
}
model {
  cluster_weight ~ dirichlet(rep_vector(1.0 / K, K));
  cluster_prob ~ beta(1, 1);
  y ~ bernoulli(dot_product(cluster_weight, cluster_prob));
}
generated quantities {
  int<lower=1, upper=K> cluster = categorical_rng(cluster_weight);
}
