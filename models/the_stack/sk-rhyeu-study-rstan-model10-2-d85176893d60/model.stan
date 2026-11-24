data {
  int N;
  int D;
  int K;
  matrix[N, D] X;
  array[N] int<lower=1, upper=K> Y;
}

transformed data {
  vector[D] Zeros;
  Zeros = rep_vector(0, D);
}

parameters {
  matrix[D, K - 1] b_raw;
}

transformed parameters {
  matrix[D, K] b;
  matrix[N, K] mu;
  b = append_col(Zeros, b_raw);
  mu = X * b;
}

model {
  for (n in 1:N)
    Y[n] ~ categorical(softmax(mu[n, ]'));
}
