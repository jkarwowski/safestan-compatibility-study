data {
    int<lower = 1> n_rows;
    int<lower = 1> n_cols;
    int<lower = 1> n_obs;

    array[n_obs] int<lower = 1, upper = n_rows> i;
    array[n_obs] int<lower = 1, upper = n_cols> j;
    array[n_obs] int<lower = 0, upper = 9> v;
}

parameters {
    array[n_rows] real a;
    array[n_rows] real x;

    array[n_cols] real b;
    array[n_cols] real y;
}

model {
    a ~ normal(0, 1);
    x ~ normal(0, 1);

    b ~ normal(0, 1);
    y ~ normal(0, 1);

    for (obs in 1:n_obs) {
        v[obs] ~ bernoulli_logit(
            a[i[obs]] + b[j[obs]] + x[i[obs]] * y[j[obs]]
        );
    }
}
