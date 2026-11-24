data {
    int N;
    array[N] real X;
    array[N] real Y;
}

parameters {
    real<lower=0> sigma;
    real Intercept;
    real b;
}

model {
    for (i in 1:N) {
        Y[i] ~ normal(Intercept + b * X[i], sigma);
    }
}