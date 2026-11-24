data {
  // wsre args
  int <lower = 0> target_dimension;
  array[target_dimension] real wf_mean;
  array[target_dimension] real<lower = 0> wf_sd;
  real <lower = 0> wf_exponent;
}

parameters {
  array[target_dimension] real x;
}

model {
  // standard normal target
  target += std_normal_lpdf(x);

  // weighting function
  target += (wf_exponent * normal_lpdf(x | wf_mean, wf_sd));
}
