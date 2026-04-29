// geometric lag time-series (Koyck 1951)
//
// http://en.wikipedia.org/wiki/Distributed_lag

data {
  int<lower=0> T; // original number of time points
  int<lower=0> T_lik; // number of modelled observations, max(T - 1, 0)
  vector[T_lik] y_obs; // original y[2:T]
  vector[T_lik] y_lag; // original y[1:(T - 1)]
  vector[T_lik] x_lik; // original x[2:T]
}
parameters {
  real alpha; // intercept
  real beta; // slope
  real<lower=0, upper=1> lambda; // lag
  real<lower=0> sigma; // noise scale
}
model {
  alpha ~ cauchy(0, 5);
  beta ~ cauchy(0, 5);
  lambda ~ uniform(0, 1);
  sigma ~ cauchy(0, 5);
  {
    vector[T_lik] mu;
    mu = alpha + beta * x_lik + lambda * y_lag;
    y_obs ~ normal(mu, sigma);
  }
}
