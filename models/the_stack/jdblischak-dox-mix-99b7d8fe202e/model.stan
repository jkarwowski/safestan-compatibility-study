data {
  int<lower=0> N; // samples (donors)
  int<lower=0> P; // cell types
  int<lower=0> K; // clusters
  matrix[N,P] y;
}
parameters {
  simplex[K] pik; // prior cluster proportions
  real<lower=.1/K> sigma; 
  array[K] vector[P] means;
}
transformed parameters {
  array[N] vector[K] logprob;
  for (n in 1:N) {
    for (k in 1:K) {
      array[P] real l; 
      for (p in 1:P) 
        l[p] = normal_lpdf(y[n,p] | means[k][p], sigma);
      logprob[n][k] = sum(l);
    }
  }
}
model {
  pik ~ dirichlet( rep_vector(1.0/K,K) ); 
  for (n in 1:N) {
    target += log_sum_exp(log(pik)+logprob[n]); 
  }
}
