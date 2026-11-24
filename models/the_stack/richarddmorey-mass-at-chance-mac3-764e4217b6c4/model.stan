data {
  
  int<lower=1> I;
  int<lower=1> J;
  array[I, J] int N;
  array[I, J] int y;
  real<lower=0,upper=1> chance_p;
}

parameters {
  vector[I] alpha;
  vector<lower=0>[I] theta;
  vector[J] beta;
  
  real<lower=0> sigma_alpha;
  real<lower=0> sigma_theta;
}

transformed parameters{
  array[I, J] real p;
  array[I, J] real x;
  array[I, J] real q;
  for(i in 1:I)
    for(j in 1:J){
      x[i,j] = theta[i] * (alpha[i] - beta[j]);
      q[i,j] = x[i,j] > 0 ? Phi( x[i,j] ) : 0.5 ;
      p[i,j] = (q[i,j] - 0.5) * 2 * (1 - chance_p) + chance_p;
    }
}

model {
  
  alpha ~ normal(0, sigma_alpha);
  theta ~ normal(0, sigma_theta);
  beta  ~ normal(0, 1);
  
  // I chose the parameters to approximately match
  // the medians of the gamma priors on precision 
  // in the JAGS model
  sigma_alpha ~ cauchy(0, 0.775);
  sigma_theta ~ cauchy(0, 0.775);
  
  for(i in 1:I)
    for(j in 1:J)
      y[i,j] ~ binomial(N[i,j], p[i,j]);
}

