data {
  int<lower=2> K; // number of categories
  int<lower=2> D; // number of predictors
  int<lower=0> N; // number of observations
  matrix[N, D] x; // predictors
  array[N] int<lower=1, upper=K> y; // observations
}
parameters {
  matrix[K, D] beta; // slopes
}
model {
  // prior
  beta ~ cauchy(0, 2.5);

  // likelihood
  y ~ categorical_logit_glm(x, rep_vector(0, K), beta');
}
