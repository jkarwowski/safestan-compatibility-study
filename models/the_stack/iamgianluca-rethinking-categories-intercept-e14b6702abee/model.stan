data {
    int N;
    int J;
    array[N] int<lower=1, upper=J> clade_id;
    vector[N] k;
}
parameters {
    array[J] real alpha;
    real<lower=0> sigma;
}
transformed parameters {
    array[N] real mu;

    for (n in 1:N) {
        mu[n] = alpha[clade_id[n]];
    }
}
model {
    sigma ~ uniform(0, 10);
    alpha ~ normal(0.6, 10);
    k ~ normal(mu, sigma);
}
