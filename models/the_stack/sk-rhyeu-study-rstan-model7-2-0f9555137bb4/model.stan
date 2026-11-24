data {
  int N;
  array[N] real Area;
  array[N] real Y;
  int N_new;
  array[N_new] real Area_new;
}

parameters {
  real b1;
  real b2;
  real<lower=0> s_Y;
}

transformed parameters {
  array[N] real mu;
  for (n in 1:N)
    mu[n] = b1 + b2*Area[n];
}

model {
  for (n in 1:N)
    Y[n] ~ normal(mu[n], s_Y);
}

generated quantities {
  array[N] real y_pred;
  array[N_new] real y_new;
  for (n in 1:N)
    y_pred[n] = normal_rng(mu[n], s_Y);
  for (n in 1:N_new)
    y_new[n] = normal_rng(b1 + b2*Area_new[n], s_Y);
}
