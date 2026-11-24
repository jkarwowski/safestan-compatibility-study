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
  array[N] real<lower=0, upper=1> maxval;
  array[N] real<lower=0> steepness;
  array[N] real<lower=0> inflection;
}

transformed parameters{
  array[N, T] real<lower=0, upper=1> performance;
  
  for(n in 1:N)
    for(t in 1:T)
      performance[n, t] = maxval[n]*(1/(1+exp(-steepness[n]*(t-inflection[n]))));
}

model{
  
  for(n in 1:N)
    for(t in 1:T)
      y[n, t] ~ binomial(trials[n, t], performance[n, t]);

  maxval ~ beta(9, 1);
  steepness ~ exponential(7);
  inflection ~ gamma(7, 1);
  
}

