data {
  int<lower=2> V; // num words
  int<lower=1> M; // num docs
  int<lower=1> N; // total word instances
  array[N] int<lower=1, upper=V> w; // word n
  array[N] int<lower=1, upper=M> doc; // doc ID for word n
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
transformed parameters {
  array[N] simplex[V] word_prob;
  for (n in 1 : N) {
    vector[V] prob = rep_vector(0, V);
    for (k in 1 : K) {
      prob += theta[doc[n], k] * phi[k];
    }
    word_prob[n] = prob;
  }
}
model {
  theta ~ dirichlet(alpha);
  phi ~ dirichlet(beta);
  w ~ categorical(word_prob);
}
