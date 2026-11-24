data {
  int<lower=2> V; // num words
  int<lower=1> M; // num docs
  array[V] int<lower=0> word_counts_1;
}
transformed data {
  int<lower=1> K = 2;
  vector<lower=0>[K] alpha; // topic prior
  vector<lower=0>[V] beta; // word prior
  for (k in 1 : K) {
    alpha[k] = 1;
  }
  for (v in 1 : V) {
    beta[v] = 1;
  }
}
parameters {
  array[M] simplex[K] theta; // topic dist for doc m
  array[K] simplex[V] phi; // word dist for topic k
}
model {
  vector[V] word_prob_1 = rep_vector(0, V);

  theta ~ dirichlet(alpha);
  phi ~ dirichlet(beta);
  for (k in 1 : K) {
    word_prob_1 += theta[1, k] * phi[k];
  }
  word_counts_1 ~ multinomial(word_prob_1);
}
