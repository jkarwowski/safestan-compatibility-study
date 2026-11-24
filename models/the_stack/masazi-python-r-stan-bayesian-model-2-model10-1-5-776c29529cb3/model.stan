data {
    int N; // num of games
    int G; // num of groups(usagi, kame)
    array[N, 2] int LW;
}

parameters {
    real b;
    array[N] ordered[2] performance;
}

transformed parameters {
    array[G] real mu;
    mu[1] = 0;
    mu[2] = b;
}

model {
    for (n in 1:N) {
        for (j in 1:2) {
            performance[n, j] ~ normal(mu[LW[n, j]], 1);
        }
    }
}

