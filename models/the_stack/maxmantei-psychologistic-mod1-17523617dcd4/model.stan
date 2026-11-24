data{
  int<lower=1> N;
  int<lower=1> T;
  array[N, T] int<lower=0, upper=8> y;
}

transformed data{
  array[N, T] int<lower=1, upper=8> trials;
  
  for(t in 1:T)
    for(n in 1:N)
      trials[n, t] = 8;
  
}

parameters{
  array[N] real<lower=0,upper=1> performance;
}

model{
  
  for(n in 1:N)
    y[n] ~ binomial(trials[n], performance[n]);
    
}

