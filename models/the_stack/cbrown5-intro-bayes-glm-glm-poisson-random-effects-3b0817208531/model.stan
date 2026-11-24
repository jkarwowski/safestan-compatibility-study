data {
  int<lower=0> N;
  int<lower=0> K;
  array[N] int y;
  vector[N] x;
  array[N] int igroup; 
}

parameters {
  real alpha;
  real beta;
  real sigma;
  array[K] real z; 
}

transformed parameters{
  vector[N] lambda;
  for (n in 1:N)
    lambda[n] = exp(alpha + beta*x[n] + z[igroup[n]]);
    
}

model {
  alpha ~ normal(0, 2);
  beta ~ normal(0,2);
  
  // Random effect
  z ~ normal(0, sigma); //note variance is random! hence 'random effect'
  sigma ~ exponential(1);
  
  //likelihood
  y ~ poisson(lambda);
  
  //for (n in 1:N)
   //target += poisson_lpmf(y[n] | lambda[n]);
}

generated quantities{
  array[N] int y_sim;
  y_sim = poisson_rng(lambda);
}




