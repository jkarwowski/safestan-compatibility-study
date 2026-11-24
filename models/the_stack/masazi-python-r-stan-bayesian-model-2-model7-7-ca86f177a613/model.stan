data {
    int N;
    array[N] int X;
    array[N] real Y;
}

parameters {
    real a;
    real b;
    real sigma;
    array[N] real x_true;
}

model {
    for (n in 1:N) {
        X[n] ~ normal(x_true[n], 2.5);
        Y[n] ~ normal(a + b*x_true[n], sigma);
    }
}