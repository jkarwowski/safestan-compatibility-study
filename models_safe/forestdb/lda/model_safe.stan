// SafeStan rewrite: Latent Dirichlet Allocation
// `word_safestan` is the protected token expansion of the original counts table.
data {
  int<lower=1> D;
  int<lower=1> V;
  int<lower=1> K;
  int<lower=0> N_tokens;
  array[N_tokens] int<lower=1, upper=D> token_doc;
  array[N_tokens] int<lower=1, upper=V> word_safestan;
}
parameters {
  array[D] simplex[K] theta;
  array[K] simplex[V] phi;
}
model {
  array[N_tokens] vector[V] word_prob;

  theta ~ dirichlet(rep_vector(1.0, K));
  phi ~ dirichlet(rep_vector(0.5, V));

  for (n in 1:N_tokens) {
    vector[V] p = rep_vector(0.0, V);
    for (k in 1:K) {
      p += theta[token_doc[n], k] * phi[k];
    }
    word_prob[n] = p;
  }

  word_safestan ~ categorical(word_prob);
}
generated quantities {
  array[D] int<lower=1, upper=K> dominant_topic;
  for (d in 1:D) {
    dominant_topic[d] = categorical_rng(theta[d]);
  }
}
