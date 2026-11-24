  
data {
  int<lower=0> sample_index;
  array[sample_index] int<lower=0> y;
  array[sample_index] real<lower=0> n;
  array[sample_index] int<lower=0> sample_race;
}
parameters {
  simplex[3] alpha;
  vector[sample_index / 3] beta;
  vector[sample_index] epsilon;
  vector[1] mu;
  vector[1] gamma;
  array[2] real<lower=0> sigma;
}
transformed parameters {
  vector[sample_index] lambda;
  
  for (i in 1:sample_index) {
    lambda[i] = (15.0/12.0) * exp(gamma[1] * log(n[i]) + mu[1] + alpha[sample_race[i]] + beta[(i+2)/3] + epsilon[i]);
  }
}
model {
  y ~ poisson(lambda);
  beta ~ normal(0, sigma[1]);
  epsilon ~ normal(0, sigma[2]);
}
