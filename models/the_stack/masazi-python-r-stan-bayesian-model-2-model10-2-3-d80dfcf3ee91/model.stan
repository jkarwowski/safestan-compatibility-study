data {
    int G; // the number of games.
    int N; // the number of player's id.
    array[G, 2] int<lower=1, upper=N> LW; // the list of game's results.
}

parameters {
    array[G] ordered[2] performance;
    vector<lower=0>[N] sigma_pf; // 勝負ムラ
    real<lower=0> sigma_mu; // パフォーマンスの平均
    vector[N] mu;
}

model {
    for (g in 1:G) {
        for (i in 1:2) {
            performance[g, i] ~ normal(mu[LW[g, i]], sigma_pf[LW[g, i]]);
        }
    }

    mu ~ normal(0, sigma_mu);
    sigma_pf ~ gamma(10, 10);
}
