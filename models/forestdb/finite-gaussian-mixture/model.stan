data {
  int<lower=1> N;
  vector[N] y;
}
parameters {
  simplex[2] theta;
  ordered[2] mu;
  vector<lower=0>[2] sigma;
}
model {
  theta ~ dirichlet(rep_vector(1.0, 2));
  mu ~ normal(0, 5);
  sigma ~ lognormal(0, 0.5);
  for (n in 1 : N) {
    target += log_mix(theta[1],
                      normal_lpdf(y[n] | mu[1], sigma[1]),
                      normal_lpdf(y[n] | mu[2], sigma[2]));
  }
}
generated quantities {
  int z_rep = categorical_rng(theta);
  real y_rep = normal_rng(mu[z_rep], sigma[z_rep]);
}
