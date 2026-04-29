// ForestDB translation: Bayesian Neural Network
data {
  int<lower=1> N;
  int<lower=1> D;
  int<lower=1> H;
  matrix[N, D] X;
  array[N] int<lower=0, upper=1> y;
}
parameters {
  matrix[D, H] w1;
  vector[H] b1;
  vector[H] w2;
  real b2;
}
model {
  vector[N] eta;

  w1 ~ normal(0, 1);
  b1 ~ normal(0, 1);
  w2 ~ normal(0, 1);
  b2 ~ normal(0, 1);

  for (n in 1:N) {
    row_vector[H] hidden = tanh(X[n] * w1 + b1');
    eta[n] = b2 + hidden * w2;
  }
  y ~ bernoulli_logit(eta);
}
generated quantities {
  vector[N] p;
  for (n in 1:N) {
    row_vector[H] hidden = tanh(X[n] * w1 + b1');
    p[n] = inv_logit(b2 + hidden * w2);
  }
}
