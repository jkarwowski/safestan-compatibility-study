functions {
  vector sir(real t, vector y, real beta, real gamma) {
    real dSdt = - beta * y[1] * y[2];
    real dIdt = beta * y[1] * y[2] - gamma * y[2];
    real dRdt = gamma * y[2];
    return to_vector([dSdt, dIdt, dRdt]);
  }
}

data {
  int<lower=1> n_obs; // how many data points
  int<lower=1> n_sample; // number of people sampled per day
  int<lower=1> n_eq; // number of equations
  real t0; // initial time
  array[n_obs] real t_obs; // sampled times
  array[n_obs] int y_obs; // sampled data points (% infected)
  
  int<lower=1> n_gen; // number of points to generate/simulate
  array[n_gen] real t_gen; // times to generate simulated data for
}

parameters {
  real<lower=0> p_beta;
  real<lower=0> p_gamma;
  real<lower=0, upper=1> S0; // initial susceptible
}

transformed parameters {
  // initial conditions
  real<lower=0, upper=1> I0 = 1. - S0;
  vector[n_eq] y0 = [S0, I0, 0.]'; 

  // run ode, results are in [n_obs x n_eq] array 
  array[n_obs] vector[n_eq] y_pred = ode_rk45(sir, y0, t0, t_obs, p_beta, p_gamma);
}

model {
  // priors
  p_beta ~ exponential(1);
  p_gamma ~ exponential(10);
  S0 ~ uniform(0., 1.);

  // sampling distribution for binomial model
  y_obs ~ binomial(n_sample, y_pred[,2]); 
}

generated quantities {
  array[n_gen] vector[n_eq] y_gen = ode_rk45(sir, y0, t0, t_gen, p_beta, p_gamma);
}
