// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N;
  array[N] real y;
  real<lower=0> sigma;
  real<lower=0, upper=1>p;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real mu1;
  real mu2;
}

model {
  for(i in 1:N )
  target+=  log_sum_exp(  log(p)+ normal_lpdf(y[i]| mu1, 1),  log(1-p)+  normal_lpdf(y[i]
  |mu2, 1));
}

generated quantities{
  array[N] real log_lik;
  for( i in 1:N)
   log_lik[i]=log_sum_exp(  log(p)+ normal_lpdf(y[i]| mu1, 1),  log(1-p)+  normal_lpdf(y[i]| mu2, 1));

}

