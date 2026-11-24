data {
    int<lower=1> N; //rows
    array[N] real Y_meas;
    array[N] real X_meas;
    array[N] real SD_Y;
    array[N] real SD_X;
    int<lower=1> K;
    array[N] int<lower=1, upper=K> scale_group;
}

parameters {
    array[N] real Y; // "true" value of Y
    array[N] real X; // "true" value of X
    array[K] real alpha;  // intercepts
    real beta;  // slope
    real<lower=0> sigma;
}

model {
    sigma ~ cauchy(0, 1);
    alpha ~ normal(0, 1.5);
    beta ~ normal(0, 1);

    Y ~ normal(0, 10);
    X ~ normal(0, 10);

    Y_meas ~ normal(Y, SD_Y);
    X_meas ~ normal(X, SD_X);

    for (i in 1:N){
        Y[i] ~ normal(alpha[scale_group[i]] + beta * X[i], sigma);
    }
}

generated quantities {
    array[N] real Y_pred;
    array[N] real log_lik;

    for (i in 1:N) {
        Y_pred[i] = normal_rng(alpha[scale_group[i]] + beta * X[i], sigma);
        log_lik[i] = normal_lpdf(Y[i] | alpha[scale_group[i]] + beta * X[i], sigma);
    }
}
