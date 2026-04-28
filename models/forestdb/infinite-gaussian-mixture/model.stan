// ForestDB translation: Infinite Gaussian Mixture
data {
  int<lower=1> K;
  int<lower=1> N;
  vector[N] y;
}
parameters {
  simplex[K] theta;
  ordered[K] mu;
  vector<lower=0>[K] sigma;
}
model {
  theta ~ dirichlet(rep_vector(1.0, K));
  mu ~ normal(0, 3);
  sigma ~ lognormal(0, 0.5);
  for (n in 1:N) {
    vector[K] lp;
    for (k in 1:K) {
      lp[k] = log(theta[k]) + normal_lpdf(y[n] | mu[k], sigma[k]);
    }
    target += log_sum_exp(lp);
  }
}
generated quantities {
  int<lower=1, upper=K> component = categorical_rng(theta);
}
