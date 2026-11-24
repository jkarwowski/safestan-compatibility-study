// simple regression example
// in stan

data {
  int<lower=0> N;
  array[N] real y;
}


parameters {
  real mu;
  real<lower=0> sigma;
}

model {

 
  //likelihood
  for (n in 1:N)
    y[n] ~ normal(mu,sigma);

}