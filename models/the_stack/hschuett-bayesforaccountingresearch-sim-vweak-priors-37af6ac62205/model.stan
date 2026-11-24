data{
  int<lower=1> N;
  array[N] real y;
  array[N] real x;
}
parameters{
  real a0;
  real a1;
  real<lower=0> sigma;
}
model{
  vector[N] mu;
  sigma ~ exponential( 1.0 / 21.0 );
  a0 ~ normal( 0 , 100 );
  a1 ~ normal( 0 , 100 );
  for ( i in 1:N ) {
    mu[i] = a0 + a1 * x[i];
  }
  y ~ normal( mu , sigma );
}
