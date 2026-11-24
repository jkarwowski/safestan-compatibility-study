data {
    int<lower=1> N;
    array[N] int<lower=0> n;
    vector<lower=0>[N] C; // offsets
}
parameters {
    array[2] real<lower=0> alpha;
    array[N] real<lower=0> lambda;
}
transformed parameters {
    array[N] real<lower=0> adj_lambda;
    for (i in 1:N)
        adj_lambda[i] = lambda[i] * C[i];
}
model {
    alpha ~ gamma(0.01, 0.01);
    lambda ~ gamma(alpha[1], alpha[2]);
    n ~ poisson(adj_lambda);
}
