data {
  int<lower=0> N; // sample size
  int<lower=0> P; // number of covariates
  int<lower=0> K; // number of classes
  array[N] vector[P] x; // covariates
  array[N] vector[K] y; // counts 
  real<lower=0> concShape; // concentration shape
  real<lower=0> concRate; // concentration rate
}
parameters {
  array[P] simplex[K] beta_raw; // symmetric K-1 dof encoding of beta
  array[P] real beta_scale; 
  array[K] real<lower=0> conc; // concentration parameter
}

model {
  // beta reparameterization (Section 5.6 in the Stan manual)
  matrix[K,P] beta;
  for (k in 1:K)
    for (p in 1:P)
      beta[k,p] = beta_scale[p] * (beta_raw[p][k] - 1.0 / K);
  
  conc ~ gamma(concShape, concRate);
  for (n in 1:N) {
    vector[K] a; 
    real suma;
    vector[K] aPlusY;
    vector[K] lGaPlusY; 
    vector[K] lGaA ;
    vector[K] s; 
    s = softmax(beta * x[n]); 
    for (k in 1:K)
      a[k] = conc[k] * s[k]; 
    // explicit construction of multinomial dirichlet
    // y ~ multinomial_dirichlet( conc * softmax(beta * x[n]) )
    suma = sum(a);
    aPlusY = a + y[n];
    for (k in 1:K) {
      lGaPlusY[k] = lgamma(aPlusY[k]);
      lGaA[k] = lgamma(a[k]);
    }
    target += lgamma(suma)+sum(lGaPlusY)-lgamma(suma+sum(y[n]))-sum(lGaA); 
  }
}
