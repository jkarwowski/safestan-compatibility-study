data {
  int<lower=1> K; // num categories
  int<lower=1> V; // num words
  int<lower=0> T; // num instances
  array[T] int<lower=1, upper=V> w; // words
  array[T] int<lower=1, upper=K> z; // categories
  array[K, K] int<lower=0> trans; // transition sufficient counts
  array[K, V] int<lower=0> emit; // emission sufficient counts
  vector<lower=0>[K] alpha; // transit prior
  vector<lower=0>[V] beta; // emit prior
}
parameters {
  array[K] simplex[K] theta; // transit probs
  array[K] simplex[V] phi; // emit probs
}
model {
  theta ~ dirichlet(alpha);
  phi ~ dirichlet(beta);

  for (k in 1 : K) {
    array[K] int trans_k = trans[k];
    trans_k ~ multinomial(theta[k]);
  }
  for (k in 1 : K) {
    array[V] int emit_k = emit[k];
    emit_k ~ multinomial(phi[k]);
  }
}
