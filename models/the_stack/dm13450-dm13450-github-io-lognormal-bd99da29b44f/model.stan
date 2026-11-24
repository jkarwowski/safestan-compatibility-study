data {
  
  int N;
  array[N] real y;
  
}

parameters {
  
  real mu;
  real<lower=0> sigma;
  
}

model {
  
  y ~ lognormal(mu, sigma);
  
}

generated quantities {
  
  vector[N] yPred;
  
  for(i in 1:N)
    yPred[i] = lognormal_rng(mu, sigma);
  
}
