// ForestDB translation: Dirichlet Process
// SafeStan-compatible rewrite: Bernoulli mixture collapsed to its exact Bernoulli marginal.
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
  real mix_prob;

  cluster_weight ~ dirichlet(rep_vector(1.0 / K, K));
  cluster_prob ~ beta(1, 1);

  mix_prob = dot_product(cluster_weight, cluster_prob);
  y ~ bernoulli(mix_prob);
}
generated quantities {
  int<lower=1, upper=K> cluster = categorical_rng(cluster_weight);
}
