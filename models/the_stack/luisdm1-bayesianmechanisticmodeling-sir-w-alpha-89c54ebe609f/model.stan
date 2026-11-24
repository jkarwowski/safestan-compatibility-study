functions {
   array[] real SIR_ODE(real t, array[] real y, array[] real theta, array[] real x_r, array[] int x_i) {
     real alpha = theta[1];
     real beta = theta[2];
     real gamma = theta[3];
     array[3] real dy_dt;
     
     dy_dt[1] = -beta*y[1]*(y[2]^alpha);
     dy_dt[2] = beta*y[1]*(y[2]^alpha) - gamma*y[2];
     dy_dt[3] = gamma*y[2];
     return dy_dt;
   }
 } // end function block


data {
  int<lower=0> TOT_POP;       // Total population size
  int<lower=0> TOT_SUBPOP;    // Number of subpopulations (compartments)
  real t0;                    // initial time
  int<lower=0> N_ts;          // Total measurements times > 0
  array[N_ts] real<lower=t0> ts;    // measurement times > 0
  
  array[TOT_SUBPOP] real y_init;     // Measurements at initial time t0
  array[N_ts, TOT_SUBPOP] real y_obs; // Array with all measurements from all populations for t > 0
  
  array[TOT_SUBPOP] real eps;       //Quantity to avoid small non-negative numbers in ODE solver
  
}

transformed data {
   array[0] real x_r;                 // no real data, use as is, needed for ODE solver
   array[0] int x_i;                  // no integer data, use as is, needed for ODE solver
}

parameters {
  array[3] real<lower=0> theta_raw; // includes alpha, beta and gamma
  array[TOT_SUBPOP] real<lower=0> mu_raw;    // initial conditions for S, I, R
  real<lower=0> sigma; // measurement error intensity
}

transformed parameters {
  array[N_ts, TOT_SUBPOP] real y_hat;  // ODE solution array
  array[TOT_SUBPOP] real<lower=0> mu;
  array[3] real<lower=0> theta;
  
  // Rescale the initial condition means of Susceptibles mu[1] by 100
  // since all mu_raw where in the same scale of between 0 and 10 of value each one
  mu[1] = mu_raw[1]*100;
  mu[2] = mu_raw[2];
  mu[3] = mu_raw[3];
  
  // Rescale the beta by pop size
  theta[1] = theta_raw[1];
  theta[2] = theta_raw[2]/TOT_POP;
  theta[3] = theta_raw[3];
  
  y_hat = integrate_ode_rk45(SIR_ODE, mu, t0, ts, theta, x_r, x_i, 1e-5, 1e-3, 5e2); 
  
}

model {
  
  y_init ~ normal(mu, sigma); // likelihood at time zero
  
  for (subpop_ix in 1:TOT_SUBPOP){
    y_obs[, subpop_ix] ~ normal(y_hat[, subpop_ix], sigma); // likelihood t > 0
  }
}

generated quantities{
  array[N_ts + 1, TOT_SUBPOP] real y_checks;
  real alpha = theta[1];
  real beta = theta[2]*TOT_POP;
  real gamma = theta[3];
  
  for (subpop_ix in 1:TOT_SUBPOP){
      y_checks[1, subpop_ix] = normal_rng(mu[subpop_ix], sigma);
    }
  
  for (time_ix in 1:N_ts){
    for (subpop_ix in 1:TOT_SUBPOP){
      y_checks[time_ix + 1, subpop_ix] = normal_rng(y_hat[time_ix, subpop_ix], sigma);
    }
    
  }
  
}
