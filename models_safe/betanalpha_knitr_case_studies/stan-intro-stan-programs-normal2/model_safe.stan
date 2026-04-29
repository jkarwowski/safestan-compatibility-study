data {
  int<lower=1> N; // Number of ys, supplied by interface
}

parameters {
  array[N] real y;  // Probabilistic variables y
  real theta; // Probabilistic variable theta
}

model {
  // Add marginal probabiltiy density for theta
  // to the joint log probability density
  theta ~ normal(0, 1);

  // Add conditional probability density for the ys
  // given theta to the joint log probabilty density
  // using the vectorized log probabilty density
  y ~ normal(theta, 1);
}
