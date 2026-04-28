data {
  int N;
}

transformed data {
  real a = 1;
  real b = -0.5;
}

generated quantities {
  real<lower=0> sigma = 0.75;
  array[N] real y;
  for (n in 1:N) y[n] = normal_rng(a * b, sigma);
}
