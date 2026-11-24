
data {
  int<lower=0> N; // genes
  int<lower=0> P; // concs
  array[N] vector[P] betas;
  array[N] vector[P] se2;
}
parameters {
  cov_matrix[P] Sigma;
}
model {
  for (n in 1:N) {
    betas[n] ~ multi_normal(rep_vector(0,P) ,Sigma + diag_matrix(se2[n]));
  }
} 
