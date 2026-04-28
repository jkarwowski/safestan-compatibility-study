// ForestDB translation: Latent Dirichlet Allocation
data {
  int<lower=1> D;
  int<lower=1> V;
  int<lower=1> K;
  array[D, V] int<lower=0> counts;
}
parameters {
  array[D] simplex[K] theta;
  array[K] simplex[V] phi;
}
model {
  for (d in 1:D) {
    theta[d] ~ dirichlet(rep_vector(1.0, K));
  }
  for (k in 1:K) {
    phi[k] ~ dirichlet(rep_vector(0.5, V));
  }
  for (d in 1:D) {
    for (v in 1:V) {
      vector[K] lp;
      for (k in 1:K) {
        lp[k] = log(theta[d, k]) + log(phi[k, v]);
      }
      target += counts[d, v] * log_sum_exp(lp);
    }
  }
}
generated quantities {
  array[D] int<lower=1, upper=K> dominant_topic;
  for (d in 1:D) {
    dominant_topic[d] = categorical_rng(theta[d]);
  }
}
