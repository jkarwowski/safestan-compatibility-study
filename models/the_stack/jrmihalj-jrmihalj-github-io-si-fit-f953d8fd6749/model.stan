
functions {
  
  // This largely follows the deSolve package, but also includes the x_r and x_i variables.
  // These variables are used in the background.
  
  array[] real SI(real t,
            array[] real y,
            array[] real params,
            array[] real x_r,
            array[] int x_i) {
      
      array[2] real dydt;
      
      dydt[1] = - params[1] * y[1] * y[2];
      dydt[2] = params[1] * y[1] * y[2] - params[2] * y[2];
      
      return dydt;
    }
  
}

data {
  int<lower = 1> n_obs; // Number of days sampled
  int<lower = 1> n_params; // Number of model parameters
  int<lower = 1> n_difeq; // Number of differential equations in the system
  int<lower = 1> n_sample; // Number of hosts sampled at each time point.
  int<lower = 1> n_fake; // This is to generate "predicted"/"unsampled" data
  
  array[n_obs] int y; // The binomially distributed data
  real t0; // Initial time point (zero)
  array[n_obs] real ts; // Time points that were sampled
  
  array[n_fake] real fake_ts; // Time points for "predicted"/"unsampled" data
}

transformed data {
  array[0] real x_r;
  array[0] int x_i;
}

parameters {
  array[n_params] real<lower = 0> params; // Model parameters
  real<lower = 0, upper = 1> S0; // Initial fraction of hosts susceptible
}

transformed parameters{
  array[n_obs, n_difeq] real y_hat; // Output from the ODE solver
  array[n_difeq] real y0; // Initial conditions for both S and I

  y0[1] = S0;
  y0[2] = 1 - S0;
  
  y_hat = integrate_ode_rk45(SI, y0, t0, ts, params, x_r, x_i);
  
}

model {
  params ~ normal(0, 2); //constrained to be positive
  S0 ~ normal(0.5, 0.5); //constrained to be 0-1.
  
  y ~ binomial(n_sample, y_hat[, 2]); //y_hat[,2] are the fractions infected from the ODE solver
  
}

generated quantities {
  // Generate predicted data over the whole time series:
  array[n_fake, n_difeq] real fake_I;
  
  fake_I = integrate_ode_rk45(SI, y0, t0, fake_ts, params, x_r, x_i);
  
}


