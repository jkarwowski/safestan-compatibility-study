data {
    int<lower=1> N; // number of data points
    array[N] real y; // the data points.
    real scalar;
    array[2] real bound_theta;
    array[2] real bound_mu_single;
    array[2] real bound_sigma_single;
    array[2] real bound_sigma_multiple;
}

parameters {
    real<lower=bound_theta[1], upper=bound_theta[2]> theta; // the mixing parameter
    real<lower=bound_mu_single[1], upper=bound_mu_single[2]> mu_single; // single star distribution mean
    real<lower=bound_sigma_single[1], upper=bound_sigma_single[2]> sigma_single; // single star distribution sigma
    real<lower=bound_sigma_multiple[1], upper=bound_sigma_multiple[2]> sigma_multiple; // multiplcity log-normal distribution sigma
    real<lower=log(mu_single + scalar * sigma_single) + pow(sigma_multiple, 2)> mu_multiple;
}

model {
   
    for (n in 1:N) {
        target += log_mix(theta,
                          normal_lpdf(y[n] | mu_single, sigma_single),
                          lognormal_lpdf(y[n] | mu_multiple, sigma_multiple));
    }
}


