data {
  int<lower=0> J; // number data points
  array[J] real y; // measured values
  array[J] real<lower=0> sigma; // s.e. of measured values
}
parameters {
  real<lower=0> mean_sigma; 
  real<lower=0> sd_sigma;
  real<lower=0> sigma_transform;
  array[J] real<lower=0> true_sigma;
  array[J] real true_value;
}


model {
  //target += cauchy_lpdf(mean_sigma, )
  target += normal_lpdf(true_sigma | mean_sigma, sd_sigma);
  target += normal_lpdf(sigma | true_sigma, sigma_transform);
  target += normal_lpdf(y | true_value, true_sigma);
  /*
  target += normal_lpdf(y[1] | change[1], sigma[1]);
  for(j in 2:J) {
    target += normal_lpdf(y[j] | y[j-1] + change[j], sigma[j]);
    target += normal_lpdf(y[j] | y[j-1] + change[j], sigma[j]);
  }*/
  //target += normal_lpdf(y | theta, sigma);
  
}
