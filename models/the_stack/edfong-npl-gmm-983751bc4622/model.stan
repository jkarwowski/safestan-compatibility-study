data {
    int<lower = 0> N; //  number of data points
    int<lower = 0> K; //  number of mixture comps
    int<lower = 0> D; //  number of dimensions

    array[N] vector[D] y; // observables

    real<lower =0> alpha0; // dirichlet prior conc
    real<lower = 0> mu_sigma0;   //means prior
    real<lower =0> sigma_sigma0; //std prior  

}

transformed data {
    vector<lower =0>[K] alpha0_vec;   //generate dirichlet prior vector
    for (k in 1:K) {
        alpha0_vec[k] = alpha0;
    }
}

parameters {
    simplex[K] pi;   // mixing probs
    array[K] vector[D] mu; // means of clusters
    array[K] vector<lower = 0>[D] sigma; //indep std of clusters
}

model {
    //priors
    pi ~ dirichlet(alpha0_vec);
    for (k in 1:K){
        mu[k] ~ normal(0.0, mu_sigma0);
        sigma[k] ~ lognormal(0.0, sigma_sigma0);
    }
    //likelihood
    for (n in 1:N) {
        array[K] real ps;
        for (k in 1:K) {
            ps[k] = log(pi[k]) + normal_lpdf(y[n]| mu[k],sigma[k]);
        }
        target+=log_sum_exp(ps);
    }
}