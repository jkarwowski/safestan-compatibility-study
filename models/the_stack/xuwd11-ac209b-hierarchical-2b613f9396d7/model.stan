data{
  int N;
  int Nschool;
  array[N] real Y;
  array[N] real LRT;
  array[N] int school;
}

parameters{
  real<lower=0> sigma;
  real<lower=0> omega0;
  real<lower=0> omega1;
  array[Nschool] real beta0;
  array[Nschool] real beta1;

}

transformed parameters{
  array[N] real mu;
  
  for(ii in 1:N){
    mu[ii] = beta0[school[ii]]+ LRT[ii]*beta1[school[ii]];
  }
}

model{
  
  Y~normal(mu,sigma);
  
  beta0~normal(0,omega0);
  beta1~normal(0,omega1);
  
  sigma~uniform(0,100);
  omega0~uniform(0,100);
  omega1~uniform(0,100);
  
}

