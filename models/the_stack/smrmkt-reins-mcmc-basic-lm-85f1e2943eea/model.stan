data {
    int<lower=1> N;
    array[N] int<lower=1, upper=5> d_d;
    array[N] int<lower=1900, upper=2014> d_f;
    array[N] int<lower=1, upper=20> d_r;
    array[N] int<lower=1, upper=20> d_s;
    array[N] int<lower=0, upper=200> d_p;
}
parameters {
    real a;
    real b_d;
    real b_f;
    real b_r;
    real b_s;
    real b_p;
    real<lower=0> s;
}
model {
    for (i in 1:N)
        d_p[i] ~ normal(a + b_d*d_d[i] + b_f*d_f[i] + b_r*d_r[i] + b_s*d_s[i], s);
}
