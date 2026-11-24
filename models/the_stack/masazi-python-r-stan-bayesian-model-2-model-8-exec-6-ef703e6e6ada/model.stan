data {
    int N;
    array[N] int y;
}

parameters {
    real b1;
    array[N] real b;
    real<lower=0> sigma;
}

transformed parameters {
    array[N] real q;
    for (n in 1:N) {
        q[n] = inv_logit(b1 + b[n]);
    }
}

model {
    for (n in 1:N) {
        b[n] ~ normal(0, sigma);
    }
    for (n in 1:N) {
        y[n] ~ binomial(8, q[n]);
    }
}

generated quantities {
    array[N] int y_pred;
    for (n in 1:N) {
        y_pred[n] = binomial_rng(9, q[n]);
    }
}