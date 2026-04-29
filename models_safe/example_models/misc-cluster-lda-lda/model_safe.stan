data {
  int<lower=2> K; // num topics
  int<lower=2> V; // num words
  int<lower=1> M; // num docs
  int<lower=1> N; // total word instances
  array[N] int<lower=1, upper=V> w; // word n
  array[N] int<lower=1, upper=M> doc; // doc ID for word n
  vector<lower=0>[K] alpha; // topic prior
  vector<lower=0>[V] beta; // word prior
}
parameters {
  array[M] simplex[K] theta; // topic dist for doc m
  array[K] simplex[V] phi; // word dist for topic k
}
model {
  array[N] vector[V] word_prob;

  theta ~ dirichlet(alpha);
  phi ~ dirichlet(beta);

  for (n in 1 : N) {
    word_prob[n] = rep_vector(0, V);
    for (k in 1 : K) {
      word_prob[n] += theta[doc[n], k] * phi[k];
    }
  }

  w ~ categorical(word_prob);
}
