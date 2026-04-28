// ForestDB translation: Dirichlet Process
data {
  int<lower=1> K;
  int<lower=1> N;
  array[N] int<lower=0, upper=1> y;
}
parameters {
  simplex[K] cluster_weight;
  vector<lower=0, upper=1>[K] cluster_prob;
}
model {
  cluster_weight ~ dirichlet(rep_vector(1.0 / K, K));
  cluster_prob ~ beta(1, 1);
  for (n in 1:N) {
    vector[K] lp;
    for (k in 1:K) {
      lp[k] = log(cluster_weight[k]) + bernoulli_lpmf(y[n] | cluster_prob[k]);
    }
    target += log_sum_exp(lp);
  }
}
generated quantities {
  int<lower=1, upper=K> cluster = categorical_rng(cluster_weight);
}
