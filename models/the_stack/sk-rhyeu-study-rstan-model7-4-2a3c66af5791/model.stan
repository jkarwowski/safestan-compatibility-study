data {
  int T;
  array[T] real Time;
  array[T] real Y;
  int T_new;
  array[T_new] real Time_new;
}

parameters {
  real<lower=0, upper=100> a;
  real<lower=0, upper=5> b;
  real<lower=0> s_Y;
}

model {
  for (t in 1:T)
    Y[t] ~ normal(a * (1 - exp(-b * Time[t])), s_Y);
}

generated quantities {
  array[T_new] real y_new;
  for (t in 1:T_new)
    y_new[t] = normal_rng(a * (1 - exp(-b * Time_new[t])), s_Y);
}
