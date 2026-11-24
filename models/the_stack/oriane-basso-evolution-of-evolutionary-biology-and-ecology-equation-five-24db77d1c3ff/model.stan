data{
  int Ob;  //number of samples across all series
  int N; // number of series
  array[Ob] real X; 
  array[Ob] int groups; // identificator of each observations 
  array[N] int index;
  array[Ob] int series_start;
}


parameters{
  real<lower=0> sigma;
  array[N] real rho;
  array[N] real aDrift;
  real mu;
  real<lower=0> rho_sig;
}

model {
  for(i in 1:Ob){   
    if(series_start[i]!=1)
      X[i] ~ normal(aDrift[groups[i]] + rho[groups[i]]*X[i-1],sigma);
    }
   
  sigma ~ cauchy(0,2.5);
  rho ~ normal(mu,rho_sig);
  mu ~ normal(0,1);
  aDrift ~ normal(0,0.1);
}

generated quantities{
  array[Ob] real XSim;
  real rho_overall;
  for(i in 1:N){
    XSim[index[i]] = 0; 
  }
  rho_overall = normal_rng(mu,rho_sig);
  
   for(i in 2:Ob){
      if(series_start[i]!=1)
      XSim[i] = normal_rng(aDrift[groups[i]] + rho[groups[i]]*XSim[i-1],sigma);
    }
   
  }

