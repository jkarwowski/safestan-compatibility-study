// ForestDB translation: Inducing Arithmetic Functions
// SafeStan rewrite: count table expanded to categorical observations.
data {
  int<lower=1> C;
  int<lower=1> K;
  int<lower=0> N_obs;
  array[N_obs] int<lower=1, upper=C> obs_context;
  array[N_obs] int<lower=1, upper=K> obs_rule;
}
parameters {
  array[C] simplex[K] rule_prob;
}
model {
  rule_prob ~ dirichlet(rep_vector(1.0, K));
  obs_rule ~ categorical(rule_prob[obs_context]);
}
generated quantities {
  array[C] int<lower=1, upper=K> sampled_rule;
  for (c in 1:C) {
    sampled_rule[c] = categorical_rng(rule_prob[c]);
  }
}
