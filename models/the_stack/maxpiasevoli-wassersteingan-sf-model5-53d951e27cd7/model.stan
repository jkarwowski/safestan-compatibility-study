  
data {
  int<lower=0> sample_index;
  array[sample_index] int<lower=0> y;
  array[sample_index] int<lower=0> n;
  array[sample_index] int<lower=0> sample_race;
  array[sample_index] int<lower=0> eth_pop;
}
parameters {
  simplex[3] alpha;
  vector[sample_index / 3] beta;
  simplex[3] t_alpha;
  vector[sample_index / 3] t_beta;
  vector[sample_index] epsilon;
  vector[sample_index] t_epsilon;
  vector[1] mu;
  array[4] real<lower = 0> sigma;
}
transformed parameters {
  vector[sample_index] lambda;
  vector[sample_index] theta;
  
  for (i in 1:sample_index) {
    theta[i] = exp(log(eth_pop[i]) + t_alpha[sample_race[i]] + t_beta[(i+2)/3] + t_epsilon[i]);
    
    lambda[i] = (15.0/12.0) * theta[i] * exp(mu[1] + alpha[sample_race[i]] + beta[(i+2)/3] + epsilon[i]);
  }
}
model {
  y ~ poisson(lambda);
  n ~ poisson(theta);
  beta ~ normal(0, sigma[1]);
  epsilon ~ normal(0, sigma[2]);
  t_beta ~ normal(0, sigma[3]);
  t_epsilon ~ normal(0, sigma[4]);
}
