data {
  int<lower=1> T; // number of observations
  array[T] real y; // observed outputs
  array[T] real y_safestan_copy; // deterministic copy of y for pre-observation recursion
}
parameters {
  real mu; // mean term
  real phi; // autoregression coeff
  real theta; // moving avg coeff
  real<lower=0> sigma; // noise scale
}
model {
  array[T] real nu; // prediction for time t
  array[T] real err; // error for time t
  
  // priors
  mu ~ normal(0, 10);
  phi ~ normal(0, 2);
  theta ~ normal(0, 2);
  sigma ~ cauchy(0, 5);
  
  nu[1] = mu + phi * mu; // assume err[0] == 0
  err[1] = y_safestan_copy[1] - nu[1];
  for (t in 2 : T) {
    nu[t] = mu + phi * y_safestan_copy[t - 1] + theta * err[t - 1];
    err[t] = y_safestan_copy[t] - nu[t];
  }
  
  // likelihood
  y ~ normal(nu, sigma);
}
