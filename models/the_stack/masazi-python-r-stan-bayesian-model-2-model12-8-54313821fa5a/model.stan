data {
    int N;
    int I;
    array[N] real Y;
    array[I] int<lower=1, upper=N> To;
    array[I] int<lower=1, upper=N> From;
}

parameters {
    vector[N] r;
    real<lower=0> sigma_r;
    real<lower=0> sigma_y;
}

model {
    target += normal_lpdf(r[To] | r[From], sigma_r);
    Y ~ normal(r, sigma_y);
    sigma_y ~ normal(0, 0.1);
}