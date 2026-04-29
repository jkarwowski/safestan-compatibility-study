// ForestDB translation: Probabilistic Context-Free Grammar
data {
  int<lower=1> C;
  int<lower=1> K;
  array[C, K] int<lower=0> counts;
}
parameters {
  array[C] simplex[K] rule_prob;
}
model {
  rule_prob ~ dirichlet(rep_vector(1.0, K));
  counts ~ multinomial(rule_prob);
}
generated quantities {
  array[C] int<lower=1, upper=K> sampled_rule;
  for (c in 1:C) {
    sampled_rule[c] = categorical_rng(rule_prob[c]);
  }
}
