data {
  int<lower=1, upper=4> calls_state;
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
  vector[4] probs;
  vector[4] p_call_if_alarm;
  vector[4] p_call_if_no_alarm;
  real p_alarm_marginal;

  p_burglary ~ beta(1, 20);
  p_earthquake ~ beta(1, 50);

  p_call_if_alarm[1] = (1 - p_john_alarm) * (1 - p_mary_alarm);
  p_call_if_alarm[2] = (1 - p_john_alarm) * p_mary_alarm;
  p_call_if_alarm[3] = p_john_alarm * (1 - p_mary_alarm);
  p_call_if_alarm[4] = p_john_alarm * p_mary_alarm;

  p_call_if_no_alarm[1] = (1 - p_john_no_alarm) * (1 - p_mary_no_alarm);
  p_call_if_no_alarm[2] = (1 - p_john_no_alarm) * p_mary_no_alarm;
  p_call_if_no_alarm[3] = p_john_no_alarm * (1 - p_mary_no_alarm);
  p_call_if_no_alarm[4] = p_john_no_alarm * p_mary_no_alarm;

  p_alarm_marginal = (1 - p_burglary) * (1 - p_earthquake) * p_alarm[1, 1]
                     + (1 - p_burglary) * p_earthquake * p_alarm[1, 2]
                     + p_burglary * (1 - p_earthquake) * p_alarm[2, 1]
                     + p_burglary * p_earthquake * p_alarm[2, 2];

  probs = p_alarm_marginal * p_call_if_alarm
          + (1 - p_alarm_marginal) * p_call_if_no_alarm;

  calls_state ~ categorical(probs);
}
generated quantities {
  real posterior_burglary_prob;
  {
    vector[4] p_call_if_alarm;
    vector[4] p_call_if_no_alarm;
    real like_alarm;
    real like_no_alarm;
    real numerator;
    real denominator;

    p_call_if_alarm[1] = (1 - p_john_alarm) * (1 - p_mary_alarm);
    p_call_if_alarm[2] = (1 - p_john_alarm) * p_mary_alarm;
    p_call_if_alarm[3] = p_john_alarm * (1 - p_mary_alarm);
    p_call_if_alarm[4] = p_john_alarm * p_mary_alarm;

    p_call_if_no_alarm[1] = (1 - p_john_no_alarm) * (1 - p_mary_no_alarm);
    p_call_if_no_alarm[2] = (1 - p_john_no_alarm) * p_mary_no_alarm;
    p_call_if_no_alarm[3] = p_john_no_alarm * (1 - p_mary_no_alarm);
    p_call_if_no_alarm[4] = p_john_no_alarm * p_mary_no_alarm;

    like_alarm = p_call_if_alarm[calls_state];
    like_no_alarm = p_call_if_no_alarm[calls_state];

    numerator = p_burglary
                * ((1 - p_earthquake)
                   * (p_alarm[2, 1] * like_alarm
                      + (1 - p_alarm[2, 1]) * like_no_alarm)
                   + p_earthquake
                     * (p_alarm[2, 2] * like_alarm
                        + (1 - p_alarm[2, 2]) * like_no_alarm));

    denominator = (1 - p_burglary)
                  * ((1 - p_earthquake)
                     * (p_alarm[1, 1] * like_alarm
                        + (1 - p_alarm[1, 1]) * like_no_alarm)
                     + p_earthquake
                       * (p_alarm[1, 2] * like_alarm
                          + (1 - p_alarm[1, 2]) * like_no_alarm))
                  + numerator;

    posterior_burglary_prob = numerator / denominator;
  }
}
