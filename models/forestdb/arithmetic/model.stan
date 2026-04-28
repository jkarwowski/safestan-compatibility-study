// ForestDB translation: Inducing Arithmetic Functions
data {
  int<lower=1> C;
  int<lower=1> K;
  array[C, K] int<lower=0> counts;
}
parameters {
  array[C] simplex[K] rule_prob;
}
model {
  for (c in 1:C) {
    rule_prob[c] ~ dirichlet(rep_vector(1.0, K));
    for (k in 1:K) {
      target += counts[c, k] * log(rule_prob[c, k]);
    }
  }
}
generated quantities {
  array[C] int<lower=1, upper=K> sampled_rule;
  for (c in 1:C) {
    sampled_rule[c] = categorical_rng(rule_prob[c]);
  }
}
