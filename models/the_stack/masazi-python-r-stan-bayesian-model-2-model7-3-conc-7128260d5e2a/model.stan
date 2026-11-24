data {
    int N;
    array[N] real time;
    array[N] real Y;

    int N_new;
    array[N_new] real time_new;
}

parameters {
    real<lower=0, upper=100> a;
    real<lower=0, upper=5> b;
    real<lower=0> sigma;
}

model {
    for (n in 1:N) {
        Y[n] ~ normal(a*(1 - exp(-b*time[n])), sigma);
    }
}

generated quantities {
    array[N] real Y_pred;
    array[N_new] real Y_new;
    for (n in 1:N) {
        Y_pred[n] = normal_rng(a*(1 - exp(-b*time[n])), sigma);
    }
    for (n in 1:N_new) {
        Y_new[n] = normal_rng(a*(1 - exp(-b*time_new[n])), sigma);
    }
}