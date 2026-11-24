data {
    int N;
    array[N] int<lower=0, upper=1> A;
    array[N] real<lower=0, upper=1> Score;
    array[N] int<lower=1, upper=3> Weather;
    array[N] int<lower=0> Y;
}

parameters {
    array[3] real b;
    real bw1;
    real bw2;
    real bw3;
}

transformed parameters {
    array[3] real bw;
    array[N] real q;

    bw[1] = bw1;
    bw[2] = bw2;
    bw[3] = bw3;
    for (n in 1:N){
        q[n] = b[1] + b[2]*A[n] + b[3]*Score[n] + bw[Weather[n]];
    }

}

model {
    for (n in 1:N) {
        Y[n] ~ bernoulli_logit(q[n]);
    }
}