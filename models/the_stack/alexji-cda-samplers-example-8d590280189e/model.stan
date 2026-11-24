data {
    int K; // number of components
    int N; // number of measurements
    array[N] real feh;
    array[N] real feherr;
    array[N] real rv;
    array[N] real rverr;
}

parameters {
    simplex[K] p; // mixing proportion
    array[K] real<lower=-500, upper=500> muv;
    array[K] real<lower=-5, upper=1> mufeh;
    array[K] real<lower=-2.0, upper=6.0> loge_sigmav; 
    array[K] real<lower=-5.0, upper=1.0> loge_sigmafeh;
}

transformed parameters {
    array[K] real sigmav = exp(loge_sigmav);
    array[K] real sigmafeh = exp(loge_sigmafeh);
}

model {
    // Initialize log of mixing proportions
    vector[K] logp = log(p);
    p[1] ~ uniform(0.6,1.0);
    
    // Prior on the component velocities for identifiability
    muv[1] ~ normal(90, 5);
    mufeh[1] ~ normal(-2.0, 0.3);
    muv[2] ~ normal(150, 40);
    mufeh[2] ~ normal(-1.5, 0.3);
    muv[3] ~ normal(0, 30);
    mufeh[3] ~ normal(-1.0, 0.3);
    loge_sigmav[1] ~ normal(1.0,1.0);
    loge_sigmav[2] ~ normal(4.5,1.0);
    loge_sigmav[3] ~ normal(4.0,1.0);
    
    // Mixture model likelihood
    for (n in 1:N) {
        // Start with log of mixing proportions
        vector[K] lps = logp;
        for (k in 1:K) {
            // Radial velocity
            lps[k] += normal_lpdf(rv[n] | muv[k], sqrt(square(rverr[n]) + square(sigmav[k])));
            // Metallicity
            lps[k] += normal_lpdf(feh[n] | mufeh[k], sqrt(square(feherr[n]) + square(sigmafeh[k])));
        }
        // Accumulate log lkhd
	target += log_sum_exp(lps);
    }
}
