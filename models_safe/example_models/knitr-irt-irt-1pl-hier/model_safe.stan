//# ---- irt-1pl-hier-stan ----
data {
  int<lower=0> I;
  int<lower=0> J;
  array[I, J] int<lower=0, upper=1> y;
}
parameters {
  vector[I] b;
  vector[J] theta;
  real mu_b;
  real<lower=0> sigma_b;
  real<lower=0> sigma_theta;
}
model {
  array[I, J] real eta;

  // hyperpriors
  mu_b ~ normal(0, 5);
  sigma_b ~ cauchy(0, 2);
  sigma_theta ~ cauchy(0, 2);
  
  // priors
  b ~ normal(mu_b, sigma_b);
  theta ~ normal(0, sigma_theta);
  
  // likelihood predictor
  for (i in 1 : I) {
    for (j in 1 : J) {
      eta[i, j] = theta[j] - b[i];
    }
  }

  // likelihood
  y ~ bernoulli_logit(eta);
}
