data {
  int N;
  int K;
  array[N] int<lower=1, upper=K> Y;
}

parameters {
  simplex[K] theta;
}

model {
  for (n in 1:N)
    Y[n] ~ categorical(theta);
}
