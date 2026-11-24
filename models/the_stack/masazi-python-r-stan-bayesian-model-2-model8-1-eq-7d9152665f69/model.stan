data {
    int N;
    array[N] real X;
    array[N] real Y;
    int N_group;
    array[N] int<lower=1, upper=N_group> KID;
}

parameters {
    real a0;
    real b0;

    array[N_group] real a;
    array[N_group] real b;

    real<lower=0> sigma_a;
    real<lower=0> sigma_b;
    real<lower=0> sigma;
}

model {
    for (n in 1:N_group){
        a[n] ~ normal(a0, sigma_a);
        b[n] ~ normal(b0, sigma_b);
    }
    for (n in 1:N) {
        Y[n] ~ normal(a[KID[n]] + b[KID[n]]*X[n], sigma);
    }
}