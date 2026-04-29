functions {
  // Hazard function
  real log_hazard(real t, real gamma) {
    return log(gamma);
  }

  // Survival function
  real log_survival(real t, real gamma) {
    return -gamma * t;
  }

  // Inverse survival function
  real inv_survival(real u, real gamma) {
    return - log(u) / gamma;
  }
}

data {
  int<lower=1> N1; // Number of observations in left-censored interval
  int<lower=1> N2; // Number of observations in uncensored interval
  int<lower=1> N3; // Number of observations in censored interval
  int<lower=1> N4; // Number of observations in right-censored interval

  int<lower=N1, upper=N1> N1_safestan_obs; // Deterministic protected copy of N1
  int<lower=N3, upper=N3> N3_safestan_obs; // Deterministic protected copy of N3
  int<lower=N4, upper=N4> N4_safestan_obs; // Deterministic protected copy of N4

  array[N2] real<lower=0> obs_times; // Observation times

  real t_min;
  real<lower=t_min> t1; // Left-censoring threshold
  real<lower=t1>    t2; // Interval-censoring left threshold
  real<lower=t2>    t3; // Interval-censoring right threshold/Right-censoring threshold
  real<lower=t3> t_max;

  int<lower=1> N_display;                 // Number of display times
  array[N_display] real<lower=0> display_times; // Display times
}

transformed data {
  int N = N1 + N2 + N3 + N4;
}

parameters {
  real<lower=0> gamma;
}

model {
  real log_S1;
  real log_S2;
  real log_S3;

  real log_p1;
  real log_p3;
  real log_p4;

  real p1;
  real p3;
  real p4;

  gamma ~ normal(0, 5);

  log_S1 = log_survival(t1, gamma);
  log_S2 = log_survival(t2, gamma);
  log_S3 = log_survival(t3, gamma);

  log_p1 = log_diff_exp(0, log_S1);
  log_p3 = log_diff_exp(log_S2, log_S3);
  log_p4 = log_S3;

  p1 = exp(log_p1);
  p3 = exp(log_p3);
  p4 = exp(log_p4);

  N1_safestan_obs ~ binomial(N1, p1);
  obs_times ~ exponential(gamma);
  N3_safestan_obs ~ binomial(N3, p3);
  N4_safestan_obs ~ binomial(N4, p4);
}

generated quantities {
  array[N_display] real display_survival;
  array[N] real<lower=0> pred_obs_times;

  for (n in 1:N_display)
    display_survival[n] = exp(log_survival(display_times[n], gamma));

  for (n in 1:N) {
    real u = uniform_rng(0, 1);
    real time = inv_survival(u, gamma);

    if (time < t1) {
      pred_obs_times[n] = 0.5 * (t_min + t1);
    } else if (time < t2) {
      pred_obs_times[n] = time;
    } else if (time < t3) {
      pred_obs_times[n] = 0.5 * (t2 + t3);
    } else {
      pred_obs_times[n] = 0.5 * (t3 + t_max);
    }
  }
}
