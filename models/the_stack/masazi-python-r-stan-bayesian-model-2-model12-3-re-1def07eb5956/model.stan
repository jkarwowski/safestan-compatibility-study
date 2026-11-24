data {
    int N;
    vector[N] Y;
}

parameters {
    real beta0;
    array[N] real<lower=-pi()/2, upper=pi()/2> beta_unif;
    real<lower=0> sigma_c;
    real<lower=0> sigma_y;
}

transformed parameters {
    array[N] real beta;
    beta[1] = beta0;
    for (n in 2:N) {
        beta[n] = beta[n-1] + sigma_c * tan(beta_unif[n-1]);  // beta[n] ~ cauchy(beta[n-1], sigma_c)
    }
}

model {
    for (n in 1:N) {
        Y[n] ~ normal(beta[n], sigma_y);
    }
}
