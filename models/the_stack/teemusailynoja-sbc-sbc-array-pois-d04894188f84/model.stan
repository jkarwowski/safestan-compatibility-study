data{
  int N; 
  array[N] int y;
}
parameters{
  real<lower = 0> lambda;
}
model{
  y ~ poisson(lambda);
}

generated quantities{
  array[25] int y_rep;
  array[25] real log_lik;
  for(i in 1:25){
    y_rep[i] = poisson_rng(lambda); 
    log_lik[i] = poisson_lpmf(y_rep[i] | lambda);
  }
  
}
