functions {
  array[] real SIR(real t,  // time
  array[] real y,           // system state {susceptible,infected,recovered}
  array[] real theta,       // parameters
  array[] real x_r,
  array[] int x_i) {
  
  array[3] real dy_dt;
  
  dy_dt[1] = - theta[1] * y[1] * y[2];
  dy_dt[2] = theta[1] * y[1] * y[2] - theta[2] * y[2];
  dy_dt[3] = theta[2] * y[2];
  
  return dy_dt;
  }
  
  }
  data {
  int<lower = 1> n_obs;       // number of days observed
  int<lower = 1> n_theta;     // number of model parameters
  int<lower = 1> n_difeq;     // number of differential equations
  int<lower = 1> n_pop;       // population 
  array[n_obs] int y;           // data, total number of infected individuals each day
  real t0;                // initial time point (zero)
  array[n_obs] real ts;         // time points observed
  int<lower =1> N_pred;
  }
  
  transformed data {
  array[0] real x_r;
  array[0] int x_i;
  }
  
  parameters {
  array[n_theta] real<lower = 0> theta; // model parameters {beta,gamma}
  real<lower = 0, upper = 1> S0;  // initial fraction of susceptible individuals
  }
  
  transformed parameters{
  array[n_obs, n_difeq] real y_hat; // solution from the ODE solver
  array[n_difeq] real y_init;     // initial conditions for both fractions of S and I
  
  y_init[1] = S0;
  y_init[2] = 1 - S0;
  y_init[3] = 0;
  y_hat = integrate_ode_rk45(SIR, y_init, t0, ts, theta, x_r, x_i);
  
  }
  
  model {
  array[n_obs] real lambda;      //poisson parameter
  
  //priors
  theta[1] ~ lognormal(0,1);
  theta[2] ~ gamma(0.004,0.02);  //Assume mean infectious period = 5 days 
  S0 ~ beta(0.5, 0.5);
  
  //likelihood
  for (i in 1:n_obs){
  lambda[i] = y_hat[i,2]*n_pop;
  }
  y ~ poisson(lambda);
  }
  
  generated quantities {
  real R_0;      // Basic reproduction number
  R_0 = theta[1]/theta[2];
}
 
 