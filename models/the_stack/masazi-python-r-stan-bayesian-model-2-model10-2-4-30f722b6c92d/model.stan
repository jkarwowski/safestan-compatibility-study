data {
    int N;
    vector[N] X;
    vector[N] Y;
    int N_group;
    array[N] int<lower=1, upper=N_group> KID;
}

parameters {
    vector[2] ab0;
    array[N_group] vector[2] ab;
    cov_matrix[2] cov_ab;

    real<lower=0> sigma;
}

transformed parameters {
    vector[N_group] a;
    vector[N_group] b;

    for (n in 1:N_group) {
        a[n] = ab[n, 1];
        b[n] = ab[n, 2];
    }
}

model {
    ab ~ multi_normal(ab0, cov_ab);

    Y ~ normal(a[KID] + b[KID] .* X, sigma);

}