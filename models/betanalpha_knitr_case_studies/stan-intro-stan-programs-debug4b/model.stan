transformed data {
  int N = 10;
  array[N] real mu;
  for (n in 1:N)
    mu[N] = n;
  print("mu = ", mu);
}

parameters {
  array[N] real x;
}

model {
  x ~ normal(mu, 1);
}
