data {
  int N;
}

transformed data {
  vector[2] mu = [-1, 3]';
  array[2] real<lower=0> sigma = {0.75, 1.25};
  real<lower=0, upper=1> theta = 0.75;
}

generated quantities {
  array[N] real y;
  for (n in 1:N) {
    if (bernoulli_rng(theta)) {
      y[n] = normal_rng(mu[1], sigma[1]);
    } else {
      y[n] = normal_rng(mu[2], sigma[2]);
    }
  }
}
