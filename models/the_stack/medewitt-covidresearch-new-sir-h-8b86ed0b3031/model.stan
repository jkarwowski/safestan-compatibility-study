//https://github.com/stan-dev/example-models/blob/master/knitr/convert-odes/sir.stan

functions {
  vector simple_SIR(real t,
                    vector y,
                    real beta,    //  contact rate
                    real gamma,
                    real p,
                    real gamma_h,
                    real omega) { // bacteria removal rate
    vector[4] dydt;

    dydt[1] = -beta * y[1] *y[2]/sum(y);
    dydt[2] = beta * y[1] *y[2]/sum(y) - gamma * y[2]*(1-p) - gamma_h * y[2]*p;
    dydt[3] = gamma_h * y[2]*p - omega * y[3];
    dydt[4] = gamma * y[2]*(1-p) +  omega * y[3];

    return dydt;
  }
}


data {
  int<lower=0> N_t;
  array[N_t] real t;
  vector[4] y0;
  array[N_t-1] int cases;
  array[N_t] int hospitalizations;
  int pred_window;
  array[N_t+pred_window] real t_pred;
}

transformed data {
  real t0 = 0;
}

parameters {
  real<lower=0> beta;
  real<lower=0> gamma;
  real<lower=0> gamma_h;
  real<lower=0> p;
  real<lower=0> omega;
  real<lower=0> phi_inv;
  real<lower=0> phi_invh;
}

transformed parameters {
  real<lower=0> phi = 1. / phi_inv;
  real<lower=0> phih = 1. / phi_invh;
  array[N_t-1] real incidence;
  array[N_t] vector<lower=0>[4] y = ode_rk45_tol(simple_SIR, y0, t0, t,
					   1e-6, 1e-6, 1000,
					   beta, gamma, p, gamma_h, omega);
	for (i in 1:(N_t-1))
  	incidence[i] = y[i, 1] - y[i + 1, 1];
}
  
model {
  
  cases ~ neg_binomial_2(incidence, phi);
  beta ~ cauchy(0, 2.5);
  gamma ~ cauchy(0, 1);
  gamma_h ~ normal(.3,.1);
  p ~ beta(5,10);
  omega ~ normal(.14, .1);
  phi_inv ~ exponential(1);
  phi_invh ~ exponential(1);
  
  hospitalizations ~ neg_binomial_2(y[, 3], phih);

}
generated quantities{
  array[N_t+pred_window-1] real incidence_out;
  array[N_t+pred_window-1] real reff;
  real r0;
  real recovery;
  array[N_t+pred_window] real census;
  array[N_t+pred_window] vector<lower=0>[4] y_pred = ode_rk45_tol(simple_SIR, y0, t0, t_pred,
					   1e-6, 1e-6, 1000,
					   beta, gamma, p, gamma_h, omega);
	for(i in 1:(N_t+pred_window-1)){
	  incidence_out[i] = y_pred[i,1] - y_pred[i+1,1];
	}
	
	for(i in 1:(N_t+pred_window-1)){
	  reff[i] = beta/gamma * y_pred[i,1]/sum(y_pred[i,]);
	}
	
	for(i in 1:(N_t+pred_window)){
	  census[i] = y_pred[i,3];
	}
	
	r0 = beta/gamma;
	recovery = 1/gamma;
					   
}
