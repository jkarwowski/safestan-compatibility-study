data {
  int<lower=0> N; 
  int<lower=0> P;
  matrix[N,P] x; 
  array[N] int<lower=0> ys;
  array[N] int<lower=0> ns;
  real<lower=0> conc; 
  real<lower=0> concShape; 
  real<lower=0> concRate; 
}
parameters {
  vector[P] beta;
}
model {
  vector[N] xb; 
  array[N] real a;
  array[N] real b;
  array[N] real p; 
  xb = x * beta;
  for (n in 1:N) {
    p[n] = inv_logit(xb[n]); 
    a[n] = conc*p[n];
    b[n] = conc*(1.0-p[n]);
  }
  // beta ~ normal(0,5);
  conc ~ gamma(concShape,concRate);
  ys ~ beta_binomial(ns, a, b);
}
