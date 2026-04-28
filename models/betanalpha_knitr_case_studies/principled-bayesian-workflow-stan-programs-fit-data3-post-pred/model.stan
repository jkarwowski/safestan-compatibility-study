data {
  int N;    // Number of observations
  array[N] int y; // Count at each observation
}

parameters {
  real<lower=0> lambda;         // Poisson intensity
  real<lower=0, upper=1> theta; // Excess zero probability
}

model {
  // Prior model
  lambda ~ inv_gamma(3.5, 9);
  theta ~ beta(3, 3);

  // Observational model that mixes a Poisson with excess zeros
  for (n in 1:N) {
    real lpdf = poisson_lpmf(y[n] | lambda);
    if (y[n] == 0)
      target += log_mix(theta, 0, lpdf);
    else
      target += log(1 - theta) + lpdf;
  }
}

// Simulate a full observation from the current value of the parameters
generated quantities {
  array[N] int y_post_pred = rep_array(0, N);

  for (n in 1:N)
    if (!bernoulli_rng(theta))
      y_post_pred[n] = poisson_rng(lambda);
}
