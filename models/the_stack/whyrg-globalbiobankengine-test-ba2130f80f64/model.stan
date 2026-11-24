  data {
    int<lower=1> N;
    array[N] real y;
  } 
  parameters {
    real mu;
  } 
  model {
    target += normal_lpdf(y | mu, 1);
  } 
