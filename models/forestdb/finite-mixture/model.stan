data {
  int<lower=1> N;
  array[N] int<lower=0, upper=1> y;
}
parameters {
  simplex[2] theta;
  ordered[2] logit_p;
}
transformed parameters {
  vector<lower=0, upper=1>[2] p = inv_logit(logit_p);
}
model {
  theta ~ dirichlet(rep_vector(1.0, 2));
  logit_p ~ normal(0, 2);
  for (n in 1 : N) {
    target += log_mix(theta[1],
                      bernoulli_lpmf(y[n] | p[1]),
                      bernoulli_lpmf(y[n] | p[2]));
  }
}
generated quantities {
  int z_rep = categorical_rng(theta);
  int y_rep = bernoulli_rng(p[z_rep]);
}
