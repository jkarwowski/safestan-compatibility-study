// Stan的に間違ったモデリング
data {
    int N;
    int T;
    array[T] real Time;
    array[N, T] real Y;

    int T_new;
    array[T_new] real Time_new;
}

parameters {
    array[N] real a;
    array[N] real b;
    real a0;
    real b0;
    real<lower=0> sigma_a;
    real<lower=0> sigma_b;
    real<lower=0> sigma;
}


model {
    for (n in 1:N) {
        a[n] ~ lognormal(a0, sigma_a);
        b[n] ~ lognormal(b0, sigma_b);
    }

    for (n in 1:N) {
        for (t in 1:T) {
            Y[n, t] ~ normal(a[n]*(1 - exp(-b[n]*Time[t])), sigma);
        }
    }
}

generated quantities {
    array[N, T_new] real y_new;
    for (n in 1:N) {
        for (t in 1:T_new) {
            y_new[n, t] = normal_rng(a[n]*(1 - exp(-b[n]*Time_new[t])), sigma);
        }
    }
}