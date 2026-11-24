data {
    int<lower=1> N; //rows
    array[N] real Y_meas;
    array[N] real X_meas;
    array[N] real<lower=0> SD_Y;
    array[N] real<lower=0> SD_X;
    array[N] real<lower=0, upper=1> X0;
    int<lower=0, upper=1> run_estimation; // a switch to evaluate the likelihood
}

parameters {
    real mu;
    real beta;
    real<lower=0> tau; //between study variance
    array[N] real eta;
    real gamma;
    array[N] real X;
}

transformed parameters {
  array[N] real alpha;
  array[N] real Y;
  for (i in 1:N) {
    alpha[i] = mu + tau * eta[i];
    Y[i] = alpha[i] + beta * X[i] + gamma * X0[i];
  }
}

model {
    mu ~ cauchy(0, 1);
    beta ~ cauchy(0, 1);
    tau ~ cauchy(0, 1);
    eta ~ normal(0, 1);
    gamma ~ normal(0, 1);

    X ~ normal(0, 2.5);
    X_meas ~ normal(X, SD_X);

  // likelihood, which we only evaluate conditionally
    if(run_estimation==1){
        for (i in 1:N){
            Y_meas[i] ~ normal(Y[i], SD_Y[i]);
        }
    }
}

generated quantities {
    array[N] real Y_pred;
    array[N] real log_lik;

    for (i in 1:N) {
        Y_pred[i] = normal_rng(mu + beta * X[i] + gamma * X0[i], tau);
        log_lik[i] = normal_lpdf(Y_meas[i] | Y[i], SD_Y[i]);
    }
}
