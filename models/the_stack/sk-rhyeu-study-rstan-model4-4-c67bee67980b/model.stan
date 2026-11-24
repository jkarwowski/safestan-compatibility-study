
data {
  int N;
  array[N] real X;
  array[N] real Y;
  int N_new;
  array[N_new] real X_new;
}

parameters {
  real a;
  real b;
  real<lower=0> sigma;
}

transformed parameters {
  array[N] real y_base;
  for (n in 1:N)
  y_base[n] = a + b * X[n];
}

model {
  for (n in 1:N)
    Y[n] ~ normal(y_base[n], sigma);
}

generated quantities{
  array[N_new] real y_base_new;
  array[N_new] real y_new;
  for (n in 1:N_new) {
    y_base_new[n] = a + b * X_new[n];
    y_new[n] = normal_rng(y_base_new[n], sigma);
  }
}

