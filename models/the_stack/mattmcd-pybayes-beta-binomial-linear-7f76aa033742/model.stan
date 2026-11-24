data {
    int<lower = 0> N;
    array[N] int<lower = 0> trial;
    array[N] int<lower = 0> success;
}
parameters {
    real <lower=0, upper=1> mu0;
    real mu_t;
    real <lower=0> sigma0;
}
transformed parameters {
    array[N] real<lower=0, upper=1> mu;
    array[N] real<lower = 0> alpha0;
    array[N] real<lower = 0> beta0;
    for (i in 1:N) {
        mu[i] = mu0 + mu_t * log(trial[i]);
        alpha0[i] = mu[i] / sigma0;
        beta0[i] = (1-mu[i])/sigma0;
    }
}
model {
  success ~ beta_binomial(trial, alpha0, beta0);
}
