data {
    int N;
    array[N] int animal_num;
}

parameters {
    real<lower=0> lambda;
}

// vectorized
model {
    animal_num ~ poisson(lambda);
}

generated quantities {
    array[N] int posterior_predictive;
    for (i in 1:N) {
        posterior_predictive[i] = poisson_rng(lambda);
    }
}
