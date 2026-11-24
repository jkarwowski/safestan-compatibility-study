data {
  int N;
  int D;
  array[N] vector[D] Y;
}

parameters {
  vector[D] mn;
  cov_matrix[D] cov;
}

model {
  Y ~ multi_normal(mn, cov);
}
