data {
    int N;
    array[N] real Y;
    array[N] real X;
    int N_group;
    int N_industry;
    array[N] int<lower=1,upper=N_group> KID;
    array[N_group] int<lower=1,upper=N_industry> K2G;
    array[N] int<lower=1,upper=N_industry> GID;
}

parameters {
    real a0;
    array[N_industry] real a1;
    array[N_group] real a;

    real b0;
    array[N_industry] real b1;
    array[N_group] real b;

    real<lower=0> sigma_a1;
    real<lower=0> sigma_b1;
    array[N_industry] real<lower=0> sigma_a;
    array[N_industry] real<lower=0> sigma_b;
    array[N_industry] real<lower=0> sigma;
}

model {
    for (n in 1:N_industry) {
        a1[n] ~ normal(a0, sigma_a1);
        b1[n] ~ normal(b0, sigma_b1);
    }
    for (n in 1:N_group) {
        a[n] ~ normal(a1[K2G[n]], sigma_a[K2G[n]]);
        b[n] ~ normal(b1[K2G[n]], sigma_b[K2G[n]]);
    }
    for (n in 1:N) {
        Y[n] ~ normal(a[KID[n]] + b[KID[n]]*X[n], sigma[GID[n]]);
    }
}