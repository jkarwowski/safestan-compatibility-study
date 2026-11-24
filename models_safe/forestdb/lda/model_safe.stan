// SafeStan rewrite: Latent Dirichlet Allocation
// Protected word counts preserve the original count-table likelihood.
data {
  int<lower=1> D;
  int<lower=1> V;
  int<lower=1> K;
  array[V] int<lower=0> word_counts_1;
}
parameters {
  array[D] simplex[K] theta;
  array[K] simplex[V] phi;
}
model {
  vector[V] word_prob_1 = rep_vector(0.0, V);

  theta ~ dirichlet(rep_vector(1.0, K));
  phi ~ dirichlet(rep_vector(0.5, V));

  for (k in 1:K) {
    word_prob_1 += theta[1, k] * phi[k];
  }
  word_counts_1 ~ multinomial(word_prob_1);
}
generated quantities {
  array[D] int<lower=1, upper=K> dominant_topic;
  for (d in 1:D) {
    dominant_topic[d] = categorical_rng(theta[d]);
  }
}
