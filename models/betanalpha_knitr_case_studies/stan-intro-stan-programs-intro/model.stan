data {
  int<lower=1> N;
  array[N] real y;
}

parameters {
  real theta;
}

model {
  target += normal_lpdf(theta | 0, 1);
  for (n in 1:N)
    target += normal_lpdf(y[n] | theta, 1);
}
