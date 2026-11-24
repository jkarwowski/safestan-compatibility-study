

data {
  int N ;
  array[N] int y ;
  array[N] real x;
}

parameters {
  //parameter we have to estimate - what's the bias on this?
  real norm_mu;
  
}

model {
  array[N] real x_prob;
  
  norm_mu ~ normal(0,5);
  
  x ~ normal(norm_mu,1);
  
  x_prob = Phi_approx(x); 
  y ~ categorical_logit(to_vector(x_prob));
}

