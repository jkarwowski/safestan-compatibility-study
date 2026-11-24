data {
  int<lower=0> N;
  int<lower=0> K;

  array[N] cov_matrix[K] sample_cov;
}
parameters {
  cov_matrix[K] phi;
}
model {
  for (i in 1:N)
    sample_cov[i] ~ wishart(1000, phi);
}
