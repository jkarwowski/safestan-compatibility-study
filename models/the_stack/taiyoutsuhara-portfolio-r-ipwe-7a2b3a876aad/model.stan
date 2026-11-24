data {
  int<lower=0> N;
  int<lower=0> M;
  matrix[N, M] X;
  array[N] real<lower=0> Y;
  array[N] real<lower=0> W;
}

parameters {
  vector[M] beta;
}

transformed parameters {
  array[N] real mu;
  for (n in 1:N) {
    mu[n] = dot_product(X[n]*W[n], beta);
  }
}

model {
  for (n in 1:N)
    Y[n] ~ normal(mu[n], M);
  for (m in 1:M)
    // normal(mean, SD)のSDに、説明変数の数を代入する。
    beta[m] ~ normal(0, M);
}
