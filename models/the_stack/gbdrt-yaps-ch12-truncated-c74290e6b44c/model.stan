data {
    int<lower=0> N;
    real U;
    array[N] real<upper=U> y;
}
parameters {
    real mu;
    real<lower=0> sigma;
}
model {
    for (n in 1:N)
        y[n] ~ normal(mu, sigma) T[,U];
}
