data {
  int<lower=0> N;
  array[N] real<lower=0> y;
}

parameters {
  array[N] real season;
  array[N] real trend;
  real s_trend;
  real s_season;
  real s_q;
}

model {
  array[N] real q;
  array[N] real cum_trend;
  for (i in 7:N)
    season[i] ~ normal(-season[i - 1] - season[i - 2] - season[i - 3] - season[i - 4] - season[i - 5] - season[i - 6], s_season);	
  for (i in 3:N)
    trend[i] ~ normal(2 * trend[i - 1] - trend[i - 2], s_trend);
  
  cum_trend[1] = trend[1];
  for (i in 2:N)
    cum_trend[i] = cum_trend[i - 1] + trend[i];
  for (i in 1:N)
    q[i] = y[i] - season[i] - cum_trend[i];
  for (i in 1:N)
    q[i] ~ normal(0, s_q);
}
