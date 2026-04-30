// ForestDB translation: Infinite Probabilistic Context-Free Grammar
// SafeStan rewrite: count rows split into protected multinomial observations.
data {
  int<lower=1> C;
  int<lower=1> K;
  array[K] int<lower=0> counts_1;
  array[K] int<lower=0> counts_2;
  array[K] int<lower=0> counts_3;
}
parameters {
  array[C] simplex[K] rule_prob;
}
model {
  rule_prob ~ dirichlet(rep_vector(1.0, K));
  counts_1 ~ multinomial(rule_prob[1]);
  counts_2 ~ multinomial(rule_prob[2]);
  counts_3 ~ multinomial(rule_prob[3]);
}
generated quantities {
  array[C] int<lower=1, upper=K> sampled_rule;
  for (c in 1:C) {
    sampled_rule[c] = categorical_rng(rule_prob[c]);
  }
}
