data {
  int N;
  array[N] real y;
}

parameters {
  real theta;
}

model {
  theta ~ normal(0,1);
  y ~ normal(theta,1);
}
