// This model works only if the number of censored and uncensored vars is the same over t
data {
    int<lower=0> T; // period t = 1,...,T
    int<lower=0> K; // number of predictors
    array[T] int<lower=0> N; // uncensored vars per time
    array[T] int<lower=0> N_cens; // cens vars per time
    array[T] vector[N[T]] y;  // arr of X for uncensored
    array[T] matrix[N[T], K] X; // arr of X for uncensored
    array[T] matrix[N_cens[T], K] X_cens; // arr of X for censored
}
parameters {
    real beta_0;
    vector[K] beta;
    real<lower=0> sigma;
    array[T] vector<lower=800>[N_cens[T]] y_cens;
}
model {
    for (t in 1:T)
      y[t] ~ normal(X[t] * beta + beta_0, sigma);
    for (t in 1:T)
      y_cens[t] ~ normal(X_cens[t] * beta + beta_0, sigma);
}