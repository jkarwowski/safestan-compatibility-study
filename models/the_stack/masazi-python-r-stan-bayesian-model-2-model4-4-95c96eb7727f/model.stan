data {
    int N;
    array[N] real X;
    array[N] real Y;

    int N_new;
    array[N_new] real X_new;
}

parameters {
    real<lower=0> sigma;
    real Intercept;
    real b;
}

transformed parameters {
    array[N] real y_base;
    for (i in 1:N) {
        y_base[i] = Intercept + b * X[i];
    }
}

model {
    for (i in 1:N) {
        Y[i] ~ normal(y_base[i], sigma);
    }
}

generated quantities {
    array[N_new] real y_base_new;
    array[N_new] real y_new;
    for (i in 1:N_new) {
        y_base_new[i] = Intercept + b * X_new[i];
        y_new[i] = normal_rng(y_base_new[i], sigma);
    }
}