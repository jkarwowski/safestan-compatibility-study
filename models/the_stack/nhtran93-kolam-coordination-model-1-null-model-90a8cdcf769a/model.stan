data {
  int<lower=0> N; // Individuals
  int<lower=1> d; // Matrix Dimension
  array[N, d, d] int<lower=0> y; // transition counts as array
}

parameters {
  array[d] simplex[d] pi;
}

transformed parameters {
  vector[N] log_lik = rep_vector(0.0, N);
  
  for(ind in 1:N) {
    for(row in 1:d) {
      log_lik[ind] += multinomial_lpmf(y[ind, row, ] | pi[row]);
    }
  }
}
model {
  for(i in 1:d){
    target += dirichlet_lpdf(pi[i] | rep_vector(1, d));
  }
  
  target += sum(log_lik);
}

