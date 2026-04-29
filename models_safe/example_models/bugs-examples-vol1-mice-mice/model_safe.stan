data {
  int<lower=0> N_uncensored;
  int<lower=0> N_censored;
  int<lower=0> M;
  array[N_uncensored] int<lower=1, upper=M> group_uncensored;
  array[N_censored] int<lower=1, upper=M> group_censored;
  array[N_censored] real<lower=0> censor_time;
  array[N_uncensored] real<lower=0> t_uncensored;
}
parameters {
  real<lower=0> r;
  array[M] real beta;
  array[N_censored] real<lower=1> t2_censored;
}
model {
  array[N_uncensored] real scale_uncensored;
  array[N_censored] real scale_censored;

  r ~ exponential(0.001);
  beta ~ normal(0, 100);

  for (n in 1 : N_uncensored) {
    scale_uncensored[n] = exp(-beta[group_uncensored[n]] / r);
  }
  for (n in 1 : N_censored) {
    scale_censored[n] = exp(-beta[group_censored[n]] / r) / censor_time[n];
  }

  t2_censored ~ weibull(r, scale_censored);
  t_uncensored ~ weibull(r, scale_uncensored);
}
generated quantities {
  array[M] real median;
  real pos_control;
  real test_sub;
  real veh_control;

  for (m in 1 : M) {
    median[m] = pow(log(2) * exp(-beta[m]), 1 / r);
  }

  veh_control = beta[2] - beta[1];
  test_sub = beta[3] - beta[1];
  pos_control = beta[4] - beta[1];
}
