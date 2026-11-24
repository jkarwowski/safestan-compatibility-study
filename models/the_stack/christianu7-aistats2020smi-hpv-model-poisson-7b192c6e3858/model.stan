
// saved as plummer_hpv.stan

data {
  int<lower=0> n_obs; // number of observations

  array[n_obs] int<lower=0> ncases;
  array[n_obs] real<lower=0> Npop;
  
  array[n_obs] real<lower=0,upper=1> phi;
}

parameters {
  real theta1;
  real<lower=0> theta2;
}

transformed parameters {
  array[n_obs] real<lower=0> mu;
  for (i in 1:n_obs) {
    mu[i] = (Npop[i]/1000)* exp(theta1 + phi[i] * theta2);
  }
}

model {
  // The likelihood
  for (i in 1:n_obs) {
    ncases[i] ~ poisson( mu[i] );
  }
}
