data {
  int N;
}

generated quantities {
  // Simulate model configuration from prior model
  real<lower=0> lambda = abs(normal_rng(0, 6));

  // Simulate data from observational model
  array[N] int y;
  for (n in 1:N) y[n] = poisson_rng(lambda);
}
