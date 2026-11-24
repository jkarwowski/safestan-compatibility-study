data {
    int N;
    array[N] real X;
    array[N] real Y;
    array[N] int KID;
    int N_group;
}

parameters {
    array[N_group] real a;
    array[N_group] real b;
    real<lower=0> sigma;
}

model {
    for (n in 1:N) {
        Y[n] ~ normal(a[KID[n]] + b[KID[n]]*X[n], sigma);
    }
}

generated quantities {
    array[N] real Y_pred;
    for (n in 1:N) {
        Y_pred[n] = normal_rng(a[KID[n]] + b[KID[n]]*X[n], sigma);
    }
}