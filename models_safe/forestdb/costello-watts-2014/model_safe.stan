// ForestDB translation: Biases from Noise
data {
  int<lower=1> G;
  int<lower=1> N;
  array[N] int<lower=1, upper=G> group;
  array[N] int<lower=0, upper=1> y;
}
parameters {
  real<lower=0> alpha;
  real<lower=0> beta;
  vector<lower=0, upper=1>[G] theta;
}
model {
  alpha ~ gamma(2, 1);
  beta ~ gamma(2, 1);
  theta ~ beta(alpha, beta);
  y ~ bernoulli(theta[group]);
}
generated quantities {
  real population_mean = alpha / (alpha + beta);
}
