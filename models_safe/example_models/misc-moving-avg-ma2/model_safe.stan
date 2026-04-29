data {
  int<lower=3> T; // number of observations
  vector[T] y; // observation at time T
  vector[T - 2] y_safestan_observed; // deterministic copy of y[3:T]
}
parameters {
  real mu; // mean
  real<lower=0> sigma; // error scale
  vector[2] theta; // lag coefficients
}
transformed parameters {
  vector[T] epsilon; // error terms
  epsilon[1] = y[1] - mu;
  epsilon[2] = y[2] - mu - theta[1] * epsilon[1];
  for (t in 3 : T) {
    epsilon[t] = y[t] - mu - theta[1] * epsilon[t - 1]
                 - theta[2] * epsilon[t - 2];
  }
}
model {
  vector[T - 2] y_hat;

  mu ~ cauchy(0, 2.5);
  theta ~ cauchy(0, 2.5);
  sigma ~ cauchy(0, 2.5);

  for (t in 3 : T) {
    y_hat[t - 2] = mu + theta[1] * epsilon[t - 1]
                   + theta[2] * epsilon[t - 2];
  }
  y_safestan_observed ~ normal(y_hat, sigma);
}
