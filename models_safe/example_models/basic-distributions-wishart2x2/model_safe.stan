// Sample from 2 x 2 Wishart
// SafeStan-compatible equivalent using a direct covariance-matrix parameter.

transformed data {
  cov_matrix[2] S = [[2, 0], [0, 0.5]];
}
parameters {
  cov_matrix[2] W;
}
transformed parameters {
  real<lower=0> sd1 = sqrt(W[1, 1]);
  real<lower=0> sd2 = sqrt(W[2, 2]);
  real rho = W[1, 2] / (sd1 * sd2);
  real cov = W[1, 2];
  real x = 0.5 * log((1 + rho) / (1 - rho));
}
model {
  W ~ wishart(4, S);
}
