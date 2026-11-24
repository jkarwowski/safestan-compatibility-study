data {
  int DAYS;
  int STUDIES;
  array[STUDIES, DAYS] int<lower=0> ami_obs;
  array[STUDIES, DAYS] real<lower=0> ami_trend;
}
parameters {
  real rr_Mon_minus_1;
  real<lower=0, upper=1> rr_decay_per_day;
}
transformed parameters {
  array[DAYS] real rr_day;
  array[STUDIES, DAYS] real ami_dst_mean;

  for (i in 1:DAYS) {
    rr_day[i] = rr_Mon_minus_1 * pow(rr_decay_per_day, (i-1)) + 1;
  }

  for (s in 1:STUDIES) {
    for (i in 1:DAYS) {
      ami_dst_mean[s][i] = ami_trend[s][i] * rr_day[i];
    }
  }
}
model {
  // rr_Mon_minus_1 ~ normal(0, 1);
  // rr_decay_per_day ~ uniform(0, 1);

  for (s in 1:STUDIES) {
    for (i in 1:DAYS) {
      ami_obs[s][i] ~ poisson(ami_dst_mean[s][i]);
    }
  }
}
