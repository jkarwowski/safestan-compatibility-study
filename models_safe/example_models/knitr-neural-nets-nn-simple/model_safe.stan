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
  vector[M * J] alpha_raw;
  vector[J * K] beta_raw;
}
transformed parameters {
  matrix[M, J] alpha;
  matrix[J, K] beta;
  for (m in 1 : M) {
    for (j in 1 : J) {
      alpha[m, j] = alpha_raw[(m - 1) * J + j];
    }
  }
  for (j in 1 : J) {
    for (k in 1 : K) {
      beta[j, k] = beta_raw[(j - 1) * K + k];
    }
  }
}
model {
  matrix[N, J] hidden;

  // priors
  alpha_raw ~ normal(0, 2);
  beta_raw ~ normal(0, 2);

  // likelihood
  hidden = tanh(x * alpha);
  y ~ categorical_logit_glm(hidden, rep_vector(0, K), beta);
}
