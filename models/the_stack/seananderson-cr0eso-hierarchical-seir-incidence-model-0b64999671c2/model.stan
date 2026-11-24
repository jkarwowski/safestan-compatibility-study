// STAN hierarchical model of SEIR outbreaks
//


functions {

  array[] real SEI(real t, // time
            array[] real y, // state
            array[] real params, // parameters (involved in fitting)
            array[] real x_r, // data (real)
            array[] int x_i) { // data (integer)
      //define states
      real S = y[1];
      real E = y[2];
      real I = y[3];
      real R = y[4];

      // define params
      real r0 = params[1];
      real sigma = params[2];
      real gamma = params[3];
      real n = params[4];
      real tau = params[5];
      real zeta = params[6];

      int intervention_switch = x_i[1];

      //define placeholder values
      real r;

      array[5] real dydt;

      // modified r0 dependent on intervention
      if(intervention_switch != 0){
        r = r0*(t<=tau) +  (t>tau)*r0*exp(zeta*(tau-t));
      }else{
        r = r0;
      }

      dydt[1] = - r * gamma * S * I; //dS
      dydt[2] = r * gamma * S * I - sigma * E; //dE
      dydt[3] = sigma * E - gamma * I; //dI
      dydt[4] = gamma * I; //dR
      dydt[5] = n * sigma * E; //d incidence

      return dydt;
    }


    // simulate random numbers from a truncated normal distribution
    // for drawing from priors
    real normal_lb_rng(real mu, real sigma, real lb) {
        real p = normal_cdf(lb | mu, sigma);  // cdf for bounds
        real u = uniform_rng(p, 1);
        return (sigma * inv_Phi(u)) + mu;  // inverse cdf for value
    }

}

data {
  int<lower = 1> n_obs; // Number of days sampled
  int<lower = 1> n_outbreaks; // Number of outbreaks observed
  int<lower = 1> n_difeq; // Number of differential equations in the system
  int<lower = 1> n_fake; // This is to generate "predicted"/"unsampled" data
  int<lower=0, upper=1> intervention_switch; // logical: include effects of intervention
  int<lower=0, upper=1> multilevel_intervention; //logical: if included intervention strength zeta is modelled as a
                                                 //         hierarchical parameter where each location has an individual zeta
  int<lower=0, upper=1> independent_r0; //logical: if true then each R0 modelled independently
                                        // useful for creating shrinkage plots

  int<lower=0, upper=1> independent_zeta; //logical: if true then each R0 modelled independently
                                        // useful for creating shrinkage plots

  array[n_obs, n_outbreaks] int y; // The binomially distributed data

  // priors
  array[n_outbreaks] real<lower=0> n_prior_mean; // mean of population size
  real<lower=0> tau_prior_mean; // mean of tau (start of intervention)

  real t0; // Initial time point (zero)
  real tn; // final time-point
  array[n_obs] real ts; // Time points that were sampled

  array[n_fake] real fake_ts; // Time points for "predicted"/"unsampled" data
}

transformed data {
  array[0] real x_r;
  array[1] int x_i;

  x_i[1] = intervention_switch;
}

parameters {


  // priors (will be updated)
  real<lower=0> r0;
  real<lower=0> r0_sigma;

  // multilevel r0 (non-centred parameterization)
  vector<lower=0>[n_outbreaks] r0k_raw;

  real std_gamma;
  real std_sigma;
  real<lower=0> tau;
  real<lower=0> zeta;

  // multilevel intervention parameters
  real<lower=0> zeta_sigma;
  vector<lower=0>[n_outbreaks] zetak_raw;

  array[n_outbreaks] real<lower = 0> n; //effective population size
  real std_S0; // Initial fraction of hosts susceptible

}

transformed parameters{
  array[n_obs, n_difeq] real y_hat; // Output from the ODE solver
  array[n_obs, n_outbreaks] real incidence;
  array[n_difeq] real y0; // Initial conditions for both S and I
  vector<lower=0>[n_outbreaks] r0k;
  vector<lower=0>[n_outbreaks] zetak;
  array[6] real params; // Model parameters
  real<lower=0> gamma; //rate (days^-1) version of inv_gamma (recovery period in days)
  real<lower=0> sigma; //rate version of inv_sigma (incubation period in days)

  real<lower = 0, upper = 1> S0; // Initial fraction of hosts susceptible

  real eps = 1e-4;

  // se rates from their periods
  gamma = 0.125 + 0.0125*std_gamma;
  sigma = 0.2 + 0.025*std_sigma;

  // S0 from standardized S0
  S0 = 0.9 + 0.01*std_S0;

  // define noncentred r0k
  if(independent_r0==1){
    r0k = 3.0 + 1.0 * r0k_raw;
  }else{
    r0k = r0 + r0_sigma * r0k_raw;
  }

  //define noncentred zetak
  if(independent_zeta == 1){
    zetak = 0.1 + 0.1 * zetak_raw;
  } else{
    zetak = zeta + zeta_sigma * zetak_raw;
  }


  for(k in 1:n_outbreaks){
    // create posterior vector
    // multilevel parameter
    params[1] = r0k[k];
    params[2] = sigma;
    params[3] = gamma;
    params[4] = n[k];

    // if including intervention has int params
    // else hard set to zero so does not effect R0
    if(intervention_switch != 0){
      params[5] = tau;
      // if no multilevel intervention draw from general distribution
      // otherwise draw from individual zetak distribution
      if(multilevel_intervention == 0){ // SA: may create sampling problems since the other still exists
        params[6] = zeta;
      }else{
        params[6] = zetak[k];
      }

    }else{ // SA: This may create sampling problems since zeta and zetak still exist:
      params[5] = 0;
      params[6] = 0;
    }



    y0[1] = S0; //S
    y0[2] = 1 - S0; //E
    y0[3] = 0; //I
    y0[4] = 0; //R
    y0[5] = 0; //cumulative incidence

    y_hat = integrate_ode_rk45(SEI, y0, t0, ts, params, x_r, x_i);
    incidence[,k] = y_hat[,5];
  }

}

model {

  // list priors that will be updated
  r0 ~ normal(3.0, 1.0); // multilevel prior previous var 1.0
  r0_sigma ~ normal(0,1);
  r0k_raw ~ std_normal();

  std_gamma ~ std_normal();
  std_sigma ~ std_normal();
  n ~ normal(n_prior_mean,10);

  std_S0 ~ std_normal();

  // if including intervention has int params
  // else hard set to zero so does not effect R0
  tau ~ normal(tau_prior_mean,1.0);
  zeta ~ normal(0.1,0.1); // previous var 0.1
  // multilevel priors for zeta. Only used if multilevel priors are switched on
  zeta_sigma ~ normal(0,1);
  zetak_raw ~ std_normal();
  //zetak ~ normal(zeta, zeta_sigma);
  for(k in 1:n_outbreaks){
    for(i in 2:n_obs){
      y[i,k] ~ poisson(max([incidence[i,k] - incidence[i-1,k], 1e-10 ]));
    }
  }


}

generated quantities {

  // Generate predicted data over the whole time series:
  array[n_fake, n_difeq] real fake_I;

  // Generate posterior predictive check
  array[n_fake] real fake_incidence;
  real diff_I;
  // Model prior parameters
  array[5] real hyper_priors;
  real<lower=0> p_r0;
  real<lower=0> p_gamma;
  real<lower=0> p_sigma;
  real<lower=0> p_tau;
  real<lower=0> p_zeta;
  //R0 predictive distribution
  real<lower=0> predictive_r0;

  fake_I = integrate_ode_rk45(SEI, y0, t0, fake_ts, params, x_r, x_i);

  fake_incidence[1] = 0;
  for(i in 2:n_fake){
    diff_I = fake_I[i,5] - fake_I[i-1,5];
    if(diff_I < 0){
      diff_I = 1e-3; // small value if incidence is negative.
    }
    fake_incidence[i] = poisson_rng(diff_I); //y_hat[,5] cumulative incidence
  }

  // generate predictive distribution for R0
  predictive_r0 = normal_lb_rng(r0,r0_sigma,0);

  // generate priors for testing purposes

  //priors
  p_r0 = normal_lb_rng(3.0, 1.0, 0);
  p_gamma = normal_lb_rng(0.167,0.005, 0);
  p_sigma = normal_lb_rng(0.2,0.01, 0);
  p_tau = normal_lb_rng(tau_prior_mean,1.0, 0);
  p_zeta = normal_lb_rng(0.1,0.1, 0);


  // create vector of priors
  hyper_priors[1] = p_r0;
  hyper_priors[2] = p_sigma;
  hyper_priors[3] = p_gamma;
  hyper_priors[4] = p_tau;
  hyper_priors[5] = p_zeta;


}





