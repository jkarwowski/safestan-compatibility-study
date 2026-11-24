
data {
  int N;
  array[N] real Y;
}

parameters {
  real mu;
}

model {
  for (n in 1:N) {
    Y[n] ~ normal(mu, 1);
  }
  mu ~ normal(0, 100); // informative prior
}

