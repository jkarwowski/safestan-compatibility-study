functions {
  real dm_lpmf(array[] int y, vector alpha) {
    int total_count = 0;
    real lp = lgamma(sum(alpha));
    for (c in 1 : size(y)) {
      total_count += y[c];
      lp += lgamma(y[c] + alpha[c]) - lgamma(alpha[c]);
    }
    return lp - lgamma(sum(alpha) + total_count);
  }
}
data {
  int<lower=1> N;
  int<lower=2> C;
  int<lower=2> K;
  array[N, C] int<lower=0> y;
}
parameters {
  simplex[K] theta;
  array[K] simplex[C] phi;
  real<lower=0> concentration;
}
model {
  theta ~ dirichlet(rep_vector(1.0, K));
  concentration ~ lognormal(0, 0.5);
  for (k in 1 : K) {
    phi[k] ~ dirichlet(rep_vector(1.0, C));
  }
  for (n in 1 : N) {
    vector[K] lp;
    for (k in 1 : K) {
      lp[k] = log(theta[k]) + dm_lpmf(y[n] | concentration * phi[k]);
    }
    target += log_sum_exp(lp);
  }
}
