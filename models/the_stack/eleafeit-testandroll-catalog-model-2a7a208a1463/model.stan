// Test & Roll: Profit Maximizing A/B Tests

// Stan code for display example meta-analysis

// Elea McDonnell Feit, efeit@gmail.com
// 18 July 2019


data {
  int<lower=1> n; // number of observations
  int<lower=1> nexpt; // number of experiments (each with multiple arms)
  vector[n] y; // observations
  array[n] int<lower=1, upper=nexpt> expt; // indictor for which experiment each obs belongs to
  array[n] int<lower=1, upper=2> treat; // indictor for whether an arm is "treatment=2 or "control"=1
}
parameters {
  array[nexpt, 2] real m; 
  array[nexpt] real t; 
  array[2] real<lower=0> s;
  real mu1;
  real Delta;
  real<lower=0> omega; 
  array[2] real<lower=0> sigma;
}
transformed parameters {
  array[nexpt] real mu2;
  for (i in 1:nexpt) {
    mu2[i] = t[i] + Delta;
  }
}
model {
  // likelihood
  for (i in 1:nexpt) {
    t[i] ~ normal(mu1, omega);
    m[i, 1] ~ normal(t[i], sigma[1]); 
    m[i, 2] ~ normal(mu2[i], sigma[2]);
  }
  for (i in 1:n) {
    y[i] ~ normal(m[expt[i], treat[i]], s[treat[i]]); 
  }
}

