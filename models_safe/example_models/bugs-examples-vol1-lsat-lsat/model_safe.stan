// LSAT: item response
// http://www.openbugs.net/Examples/Lsat.html

data {
  int<lower=0> N; // 1000, number of students
  int<lower=0> R; // 32, number of patterns of results: 2^T
  int<lower=0> T; // 5, number of questions
  array[R] int<lower=0> culm;
  array[R, T] int<lower=0> response;
  array[T * N] int<lower=0> r_safestan;
}
parameters {
  array[T] real alpha;
  vector[N] theta;
  real<lower=0> beta;
}
model {
  vector[T * N] eta;

  alpha ~ normal(0, 100.);
  theta ~ normal(0, 1);
  beta ~ normal(0.0, 100.);

  for (k in 1 : T) {
    for (j in 1 : N) {
      eta[(k - 1) * N + j] = beta * theta[j] - alpha[k];
    }
  }
  r_safestan ~ bernoulli_logit(eta);
}
generated quantities {
  real mean_alpha;
  array[T] real a;
  mean_alpha = mean(alpha);
  for (t in 1 : T) {
    a[t] = alpha[t] - mean_alpha;
  }
}
