// ForestDB translation: Gaussian Process Classifier
data {
  int<lower=1> N;
  vector[N] x;
  array[N] int<lower=0, upper=1> y;
}
parameters {
  real<lower=0> length_scale;
  real<lower=0> sigma_f;
  vector[N] eta;
}
transformed parameters {
  vector[N] f;
  {
    matrix[N, N] K;
    for (i in 1:N) {
      for (j in 1:N) {
        K[i, j] = square(sigma_f)
                  * exp(-0.5 * square((x[i] - x[j]) / length_scale));
      }
      K[i, i] += 1e-6;
    }
    f = cholesky_decompose(K) * eta;
  }
}
model {
  length_scale ~ lognormal(0, 0.5);
  sigma_f ~ lognormal(0, 0.5);
  eta ~ normal(0, 1);
  y ~ bernoulli_logit(f);
}
generated quantities {
  vector[N] p = inv_logit(f);
}
