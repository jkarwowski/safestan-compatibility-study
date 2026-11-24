data {
  int N;
  array[N] real X;
  array[N] real Y;
}

parameters {
  real a;
  real b;
  real<lower=0> sigma;
}

transformed parameters {
  array[N] real mu;
  for (n in 1:N)
    mu[n] = a + b * X[n];
}

model {
  for (n in 1:N)
    Y[n] ~ normal(mu[n], sigma);
}
