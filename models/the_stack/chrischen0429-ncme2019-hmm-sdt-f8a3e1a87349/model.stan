data {
  int<lower=0> N;
  int<lower=0> I;
  int<lower=0> J; 
  array[I, J, N] int y;
  array[J, N] int z;
}

parameters {
  array[J, N] real c;
  array[J] real<lower=0> d;
  array[I] real theta;
  array[J] real b; 
}

transformed parameters{
  array[I, J] real<lower=0,upper=1> lambda;
  for (i in 1:I){
    for (j in 1:J){
      lambda[i,j] = 1 / (1 + exp(b[j] - theta[i]));   
    }
  }
}

model {
  theta ~ normal(0,1);
  b ~ normal(0,2);
  d ~ lognormal(0,0.5);

  for (j in 1:J){
    for (n in 1:N){
      c[j,n] ~ normal((1/2)*d[j]*z[j,n],1);
     for (i in 1:I){
            y[i,j,n] ~ bernoulli( lambda[i,j] * (1 - normal_cdf(c[j,n] - d[j] * z[j,n] |0,1)) + (1 - lambda[i,j]) * (1 - normal_cdf(c[j,n] |0,1)));
          }
        }
    }
}
