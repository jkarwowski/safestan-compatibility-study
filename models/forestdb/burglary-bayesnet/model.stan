data {
  array[2] int<lower=0, upper=1> calls;
  array[2, 2] real<lower=0, upper=1> p_alarm;
  real<lower=0, upper=1> p_john_alarm;
  real<lower=0, upper=1> p_john_no_alarm;
  real<lower=0, upper=1> p_mary_alarm;
  real<lower=0, upper=1> p_mary_no_alarm;
}
parameters {
  real<lower=0, upper=1> p_burglary;
  real<lower=0, upper=1> p_earthquake;
}
model {
  p_burglary ~ beta(1, 20);
  p_earthquake ~ beta(1, 50);
  {
    vector[4] lp;
    int idx = 1;
    for (b in 0 : 1) {
      for (e in 0 : 1) {
        real pa = p_alarm[b + 1, e + 1];
        real lp_calls_if_alarm = bernoulli_lpmf(calls[1] | p_john_alarm)
                                 + bernoulli_lpmf(calls[2] | p_mary_alarm);
        real lp_calls_if_no_alarm = bernoulli_lpmf(calls[1] | p_john_no_alarm)
                                    + bernoulli_lpmf(calls[2] | p_mary_no_alarm);
        real lp_alarm = log_sum_exp(bernoulli_lpmf(1 | pa) + lp_calls_if_alarm,
                                    bernoulli_lpmf(0 | pa) + lp_calls_if_no_alarm);
        lp[idx] = bernoulli_lpmf(b | p_burglary)
                  + bernoulli_lpmf(e | p_earthquake)
                  + lp_alarm;
        idx += 1;
      }
    }
    target += log_sum_exp(lp);
  }
}
generated quantities {
  real posterior_burglary_prob;
  {
    vector[4] lp;
    int idx = 1;
    for (b in 0 : 1) {
      for (e in 0 : 1) {
        real pa = p_alarm[b + 1, e + 1];
        real lp_calls_if_alarm = bernoulli_lpmf(calls[1] | p_john_alarm)
                                 + bernoulli_lpmf(calls[2] | p_mary_alarm);
        real lp_calls_if_no_alarm = bernoulli_lpmf(calls[1] | p_john_no_alarm)
                                    + bernoulli_lpmf(calls[2] | p_mary_no_alarm);
        real lp_alarm = log_sum_exp(bernoulli_lpmf(1 | pa) + lp_calls_if_alarm,
                                    bernoulli_lpmf(0 | pa) + lp_calls_if_no_alarm);
        lp[idx] = bernoulli_lpmf(b | p_burglary)
                  + bernoulli_lpmf(e | p_earthquake)
                  + lp_alarm;
        idx += 1;
      }
    }
    posterior_burglary_prob = exp(log_sum_exp(lp[3], lp[4]) - log_sum_exp(lp));
  }
}
