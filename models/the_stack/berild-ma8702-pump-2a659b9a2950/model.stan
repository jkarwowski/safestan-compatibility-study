data {
  int<lower=0> N;         // number of pumps
  array[N] int y;               // number of failiures
  array[N] real t;              // operation time of pump
}
parameters {
  array[N] real<lower=0> lambda;       // expected count per time unit
  real<lower=0> alpha;          // population treatment effect
  real<lower=0> beta;           // population treatment effect
}
model {
  target+=exponential_lpdf(alpha | 1.0);  // log-Prior alpha
  target+=gamma_lpdf(beta | 0.1, 1.0);    // log-Prior beta
  for (i in 1:N){
    target+=gamma_lpdf(lambda[i] | alpha, beta);  // log-Conjugate prior for all lambda_i
    target+=poisson_lpmf(y[i] | lambda[i]*t[i]);  // log-likelihood for all observations
  }
}

