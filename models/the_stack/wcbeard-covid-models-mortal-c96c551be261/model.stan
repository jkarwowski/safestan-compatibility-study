/*
N: // rows
S: // states
p_inf: infection rate
*/
data {
    int N;               
    int S;
    array[N] int<lower=1> npos_delayed;
    array[N] int<lower=1> ntot_delayed;
    // int<lower=1, upper> state[N];
}

parameters {
    real<lower=0, upper=1> p_inf;
}

model {
    p_inf ~ beta(1, 1);
    npos_delayed ~ binomial(ntot_delayed, p_inf);
}