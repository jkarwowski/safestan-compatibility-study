functions {
  /**
   * Return the application of tanh() elementwise to the specified
   * matrix.  // FIXME(carpenter): remove when tanh vectorized
   *
   * @param u Input matrix.
   * @return 
   */
  matrix tanh_eltwise(matrix u) {
    matrix[rows(u), cols(u)] tanh_u;
    for (j in 1 : cols(u)) {
      for (i in 1 : rows(u)) {
        tanh_u[i, j] = tanh(u[i, j]);
      }
    }
    return tanh_u;
  }
  
  /**
   * Returns linear predictor for restricted Boltzman machine (RBM).
   * Assumes one-hidden layer with logistic sigmoid activation. 
   *
   * @param x Predictors (N x M)
   * @param alpha First-layer weights (M x J)
   * @param beta Second-layer weights (J x (K - 1))
   * @return Linear predictor for output layer of RBM.
   */
  matrix rbm(matrix x, matrix alpha, matrix beta) {
    return tanh_eltwise(x * alpha) * beta;
  }
}
data {
  int<lower=0> N; // observations (MNIST: 60K)
  int<lower=0> M; // predictors   (MNIST: 784)
  matrix[N, M] x; // data matrix  (MNIST: 60K x 784 = 47M)
  int<lower=2> K; // number of categories (MNIST: 10)
  array[N] int<lower=1, upper=K> y; // categories
  int<lower=1> J; // number of hidden units (e.g. 100)
}
transformed data {
  matrix[M, N] xt;
  vector[N] ones;
  xt = x';
  ones = rep_vector(1, N);
}
parameters {
  vector[M * J] alpha_raw;
  vector[J * (K - 1)] beta_raw;
}
transformed parameters {
  matrix[M, J] alpha;
  matrix[J, K - 1] beta;
  for (m in 1 : M) {
    for (j in 1 : J) {
      alpha[m, j] = alpha_raw[(m - 1) * J + j];
    }
  }
  for (j in 1 : J) {
    for (k in 1 : (K - 1)) {
      beta[j, k] = beta_raw[(j - 1) * (K - 1) + k];
    }
  }
}
model {
  matrix[J, K] beta_full;
  matrix[N, J] hidden;
  matrix[N, K - 1] eta;

  alpha_raw ~ normal(0, 2);
  beta_raw ~ normal(0, 2);

  eta = rbm(x, alpha, beta);
  hidden = tanh_eltwise(x * alpha);
  for (j in 1 : J) {
    beta_full[j, 1] = 0;
    for (k in 2 : K) {
      beta_full[j, k] = beta[j, k - 1];
    }
  }

  y ~ categorical_logit_glm(hidden, rep_vector(0, K), beta_full);
}
