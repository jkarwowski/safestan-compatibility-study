data {
    int N;
    array[N] int<lower=0, upper=1> A;
    array[N] real<lower=0, upper=1> Score;
    array[N] real<lower=0, upper=1> Weather;
    array[N] int<lower=0> Y;
}

parameters {
    real b1;
    real b2;
    real b3;
    real b4;
}

transformed parameters {
    array[N] real q;
    for (n in 1:N) {
        q[n] = inv_logit(b1 + b2*A[n] + b3*Score[n] + b4*Weather[n]);
    }
}

model {
    for (n in 1:N) {
        Y[n] ~ bernoulli(q[n]);
    }
}