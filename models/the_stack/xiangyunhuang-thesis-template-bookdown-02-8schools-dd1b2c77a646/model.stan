// saved as 8schools.stan
data {
  int<lower=0> J; // number of schools 
  array[J] real y; // estimated treatment effects
  array[J] real<lower=0> sigma; // s.e. of effect estimates 
}
parameters {
  real mu; // population mean
  real<lower=0> tau; // population sd
  array[J] real eta; // school-level errors
}
transformed parameters {
  array[J] real theta;  // schools effects
  for (j in 1:J)
    theta[j] = mu + tau * eta[j];
  // theta = mu + tau*eta;
}
model {
  // set prior for mu or uniform prior distribution default
  // target += normal_lpdf(mu  | 0, 10); 
  // target += cauchy_lpdf(tau | 0, 25); # the same as mu
  target += normal_lpdf(eta | 0, 1);
  target += normal_lpdf(y | theta, sigma); // target distribution
  // y ~ normal(theta, sigma);
}
