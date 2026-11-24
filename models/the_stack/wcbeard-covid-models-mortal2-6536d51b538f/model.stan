/*
Estimate infection rate as auto-regressive
  time series.
N: // rows
perc_delayed: infection rate (positive / total) ~4 days ago
prev_perc_delayed: infection rate the day before that
*/
data {
    int N;
    // int S;
    array[N] int<lower=1> npos_delayed;
    array[N] int<lower=1> ntot_delayed;
    // int<lower=1, upper=S> state[N];
    array[N] real<lower=0, upper=1> perc_delayed;
    array[N] real<lower=0, upper=1> prev_perc_delayed;
}

parameters {
    real<lower=0> p_sig;
    vector<lower=0, upper=1>[N] p_delay;
}

model {
    p_delay ~ normal(prev_perc_delayed, p_sig);
    p_sig ~ normal(0, 2);
    // p_inf ~ normal(p_state_prev, p_sig);
    npos_delayed ~ binomial(ntot_delayed, p_delay);
}