data {
  int<lower=1> K;
  int<lower=1> N;
  vector[N] Y;
}

parameters {
  ordered[K] mu;
  array[K] real<lower=0> sd_set;
}

model {
  vector[K] lp;
  mu ~ normal(1, 1);
  sd_set ~ exponential(1);

  for(i in 1:N) {
    for(j in 1:K) {
      lp[j] = normal_lpdf(Y[i] | mu[j], sd_set[j]);
    }
    target += log_sum_exp(lp);
  }
}
