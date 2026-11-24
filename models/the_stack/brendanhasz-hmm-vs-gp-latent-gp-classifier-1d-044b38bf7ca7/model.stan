data {
    int<lower=1> N; //number of datapoints
    int<lower=2> K; //number of classes
    array[N] real x;      //independent variable
    array[N] int<lower=0, upper=1> y;  //observations (dep. var.)
}

transformed data {
  real delta = 1e-9;
}

parameters {
  real<lower=0> rho;   //length scale
  real<lower=0> alpha; //signal standard deviation
  real a;              //bias
  vector[N] eta;       //latent ... something?
}

model {
  
  // Latent GP mean
  vector[N] f;
  {
    matrix[N, N] S = gp_exp_quad_cov(x, alpha, rho);
    for (n in 1:N)
      S[n, n] = S[n, n] + delta;
    f = cholesky_decompose(S) * eta;
  }

  // Priors
  rho ~ inv_gamma(5, 5);
  alpha ~ normal(0, 1);
  a ~ normal(0, 1);
  eta ~ normal(0, 1);
  
  // Observations
  y ~ bernoulli_logit(a + f);
  
}
