data {
  int<lower = 0> K;
  int<lower = 0> N;
  matrix[N, K] x;
  array[N] int y;

  int N_test;
  matrix[N_test, K] x_test;
  array[N_test] int y_test;
}
parameters {
  real alpha;
  vector[K] beta;
}
model {
  alpha ~ normal(0, 2);
  beta ~ normal(0, 2);
  y ~ bernoulli_logit(alpha + x * beta);
}
generated quantities {
  vector[N_test] E_y_test = inv_logit(alpha + x_test * beta);
  real log_loss = -bernoulli_logit_lpmf(y_test | alpha + x_test * beta);
  real sq_loss = dot_self(to_vector(y_test) - E_y_test);
}
