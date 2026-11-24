data {
  int<lower=1> N;            
  int K;
  array[N] vector[K] y;
  int P;
}

parameters {
  vector[K] alpha;                   
  real beta;                  
  vector[K] c0;                  
  array[P] matrix[K, K] phi;                  
  cov_matrix[K] Sigma;
}
model {
  array[N] vector[K] err;
  c0 ~ normal(0, 10);
  beta ~ normal(0, 1);
  alpha ~ normal(0, 1);
  for(i in 1:K)
    for(j in 1:K)
      for(p in 1:P)
        phi[p][i,j] ~ normal(0, 1);
    
  for (t in (P+2):N) {
    err[t,] = to_vector(y[t-1,]) + c0 + alpha * (to_row_vector({1,-beta}) * to_vector(y[t-1,]));
    for(p in 1:P)
      err[t,] += (phi[p] * to_vector(y[t-p,] - y[t-p-1,]));
  }
  y[(P+2):N] ~ multi_normal(err[(P+2):N], Sigma);
  
}





