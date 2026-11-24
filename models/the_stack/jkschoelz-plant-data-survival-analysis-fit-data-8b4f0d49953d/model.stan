data{
  int Nobs;
  int Ncens;
  array[Nobs] real yobs;
  array[Ncens] real ycens;
}
transformed data {
  array[Nobs] real yminus;
  int Ntot = Nobs + Ncens;
  
  for(n in 1:Nobs){
    yminus[n] = yobs[n] - 1;
  }
}
parameters{
  real<lower=0> alpha;
  real beta;
}
model{
  beta ~ normal(0,4);
  alpha ~ lognormal(0,5);
  
  target += weibull_lpdf(yobs | alpha, exp(beta));
  target += weibull_lccdf(ycens | alpha, exp(beta));
}
generated quantities {
  array[Ntot] real ypred;
  
  for(n in 1:Ntot){
    ypred[n] = weibull_rng(alpha, exp(beta));
  }
}

