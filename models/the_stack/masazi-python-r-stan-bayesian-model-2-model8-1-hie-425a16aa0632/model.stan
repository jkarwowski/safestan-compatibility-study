data {
    int N;
    array[N] real X;
    array[N] real Y;
    int N_group;
    array[N] int<lower=1, upper=N_group> KID;
}

parameters {
    real a0;
    array[N_group] real ak;
    real<lower=0> sigma_a;
    real b0;
    array[N_group] real bk;
    real<lower=0> sigma_b;
    real<lower=0> sigma;
}

transformed parameters {
    array[N_group] real a;
    array[N_group] real b;
    for (n in 1:N_group) {
        a[n] = a0 + ak[n];
        b[n] = b0 + bk[n];
    }
}

model {
    for (n in 1:N_group) {
        ak[n] ~ normal(0, sigma_a);
        bk[n] ~ normal(0, sigma_b);
    }
    for (n in 1:N) {
        Y[n] ~ normal(a[KID[n]] + b[KID[n]]*X[n], sigma);
    }
}

generated quantities {
    array[N] real Y_pred;
    array[N_group] real ak_pred;
    array[N_group] real bk_pred;
    for (n in 1:N_group) {
        ak_pred[n] = normal_rng(0, sigma_a);
        bk_pred[n] = normal_rng(0, sigma_b);
    }
    for (n in 1:N) {
        Y_pred[n] = normal_rng(a[KID[n]] + b[KID[n]]*X[n], sigma);
    }
}
