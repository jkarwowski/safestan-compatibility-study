data {
  int<lower=0> N; // 1000, number of students
  int<lower=1> R; // 32, number of patterns of results: 2^T
  int<lower=0> T; // 5, number of questions
  array[R, T] int<lower=0, upper=1> response;
  array[N] int<lower=1, upper=R> pattern_id;
}
parameters {
  array[T] real alpha;
  vector[N] theta;
  real<lower=0> beta;
}
model {
  array[N] vector[R] eta;

  alpha ~ normal(0, 100.);
  theta ~ normal(0, 1);
  beta ~ normal(0.0, 100.);

  for (j in 1 : N) {
    for (i in 1 : R) {
      eta[j][i] = 0;
      for (k in 1 : T) {
        real q;
        q = beta * theta[j] - alpha[k];
        eta[j][i] += response[i, k] * q - log1p_exp(q);
      }
    }
  }
  pattern_id ~ categorical_logit(eta);
}
generated quantities {
  real mean_alpha;
  array[T] real a;
  mean_alpha = mean(alpha);
  for (t in 1 : T) {
    a[t] = alpha[t] - mean_alpha;
  }
}
