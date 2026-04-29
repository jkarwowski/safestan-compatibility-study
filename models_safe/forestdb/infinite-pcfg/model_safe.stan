// ForestDB translation: Infinite Probabilistic Context-Free Grammar
// SafeStan-compatible rewrite: counts are represented as expanded categorical observations.
data {
  int<lower=1> C;
  int<lower=1> K;
  array[C, K] int<lower=0> counts;
  int<lower=0> N_obs;
  array[N_obs] int<lower=1, upper=C> obs_class;
  array[N_obs] int<lower=1, upper=K> rule_obs;
}
parameters {
  array[C] simplex[K] rule_prob;
}
model {
  rule_prob ~ dirichlet(rep_vector(1.0, K));
  rule_obs ~ categorical(rule_prob[obs_class]);
}
generated quantities {
  array[C] int<lower=1, upper=K> sampled_rule;
  for (c in 1:C) {
    sampled_rule[c] = categorical_rng(rule_prob[c]);
  }
}
