data {
  int N;
  array[N] real X;
  array[N] real Y;
  int N_new;
  array[N_new] real X_new;
}

parameters {
  real a;
  real<lower=0> b;
  real<lower=0, upper=30> x0;
  real<lower=0> s_Y;
}

model {
  for (n in 1:N)
    Y[n] ~ normal(a + b * (X[n] - x0)^2, s_Y);
}

generated quantities {
  array[N_new] real y_new;
  for (n in 1:N_new)
    y_new[n] = normal_rng(a + b * (X_new[n] - x0)^2, s_Y);
}
