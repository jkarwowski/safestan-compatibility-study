functions {
    // Define Michaelis-Menten model
    array[] real enzyme_kinetics(
        real t,  // time
        array[] real s,  // substrate concentration
        array[] real theta, // parameters (V_max, K_M)
        data array[] real x_r,
        data array[] int x_i
    ) {
        // Initialize dS/dt
        array[1] real ds_dt;
        // Compute dynamics
        ds_dt[1] = - theta[1] * s[1] / (theta[2] + s[1]);
          
    return ds_dt;
    }
}

data {
    // Inference information
    int<lower=1> n_replicate;  // number of replicates
    int<lower=1> n_sample;  // number of time samples
    array[n_replicate, n_sample] real t_sample;  // time points observed
    array[n_replicate, n_sample] real s_;  // data, substrate concentration
    real t0;  // Initial time

    //  Simulation information
    int<lower=1> n_sim;  // number of time points for numerical integration
    array[n_sim] real t_sim;  // time points for numerical integration

    // Parameters for prior distributions
    array[2] real vmax_param;  // parameters for prior dis. of V_max
    array[2] real km_param;  // parameters for prior dis. of K_M
    array[2] real s0_param;  // parameters for prior dis. of s0
    array[2] real sigma_param;  // parameters for prior dis. of sigma^2 
}

transformed data {
    array[0] real x_r;
    array[0] int x_i;
}

parameters {
    // Initialize parameters
    real<lower=0> vmax_;  // maximum catalytic rate
    real<lower=0> km_;  // Michaelis-Menten constant
    real<lower=0> s0_;  // Michaelis-Menten constant
    real<lower=0> sigma_;  // Observational error
}

transformed parameters{
    // Pack parameters together for ODE solver
    array[2] real<lower=0> theta;  
    theta[1] = vmax_;
    theta[2] = km_;

    // Convert s0_ to the right format
    array[1] real s0;
    s0[1] = s0_;

    
}

model {
    // Priors
    vmax_ ~ normal(vmax_param[1], vmax_param[2]);
    km_ ~ normal(km_param[1], km_param[2]);
    s0_ ~ normal(s0_param[1], s0_param[2]);
    sigma_ ~ normal(sigma_param[1], sigma_param[2]); 
    
    // Likelihood
    
    // Loop through replicates
    for (j in 1:n_replicate) {
        // Numerically integrate the SIR ODEs
        array[n_sample, 1] real s_hat;   // solution from the ODE solver
        s_hat = integrate_ode_rk45(
            enzyme_kinetics, s0, t0, t_sample[j, :], theta, 
            x_r, x_i
        );

        s_[j,:] ~ normal(s_hat[:, 1], sigma_);
    }
}

generated quantities {
    // Run numerical integration with a finer grid 
    array[n_sim, 1] real s_sim;
    s_sim = integrate_ode_rk45(enzyme_kinetics, s0, t0, t_sim, theta, x_r, x_i);
    
    // Simulate observational model
    array[n_sim] real s_tilde;
    for (i in 1:n_sim) {
        s_tilde[i] = normal_rng(s_sim[i, 1], sigma_);
    }
}