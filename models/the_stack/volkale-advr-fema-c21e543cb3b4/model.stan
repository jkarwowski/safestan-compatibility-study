data {
    int<lower=1> N; //rows
    array[N] real Y;
    array[N] real<lower=0> SD_Y;
    int<lower=0, upper=1> run_estimation; // a switch to evaluate the likelihood
}

parameters {
    real mu;
}

model {
    mu ~ cauchy(0, 1);

  // likelihood, which we only evaluate conditionally
    if(run_estimation==1){
        for (i in 1:N){
            Y[i] ~ normal(mu, SD_Y[i]);
        }
    }
}

generated quantities {
    array[N] real Y_pred;
    array[N] real log_lik;

    for (i in 1:N) {
        Y_pred[i] = normal_rng(mu, SD_Y[i]);
        log_lik[i] = normal_lpdf(Y[i] | mu, SD_Y[i]);
    }
}
