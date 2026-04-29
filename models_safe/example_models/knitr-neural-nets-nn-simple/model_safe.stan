/**
 * One layer RBM.
 */
data {
  int<lower=0> N; // num train instances
  int<lower=0> M; // num train predictors
  matrix[N, M] x; // train predictors
  int<lower=2> K; // num categories
  array[N] int<lower=1, upper=K> y; // train category
  int<lower=1> J; // num hidden units
}
parameters {
  matrix[M, J] alpha;
  matrix[J, K] beta;
}
model {
  matrix[N, J] hidden;

  // priors
  alpha ~ normal(0, 2);
  beta ~ normal(0, 2);

  // likelihood
  hidden = tanh(x * alpha);
  y ~ categorical_logit_glm(hidden, rep_vector(0, K), beta);
}
