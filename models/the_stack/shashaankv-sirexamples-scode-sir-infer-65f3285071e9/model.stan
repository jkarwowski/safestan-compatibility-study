
functions{
  array[] real SIR(real t,  // time
            array[] real ln_init,// system state {infected,cases,susceptible}
            array[] real theta,
            array[] real x_r,
            array[] int x_i)

    {
        array[3] real dy_dt;

        real kI = theta[1];
        real kR = theta[2];
        real lS = ln_init[1];  // susceptible
        real lI = ln_init[2];  // infected
        real lR = ln_init[3];  // recovered

        dy_dt[1] = -kI*lS*lI; //dS
        dy_dt[2] = kI*lS*lI - kR*lI; //dI
        dy_dt[3] = kR*lR; //dR
        return dy_dt;
    }
}

data {
    int<lower=1> Nsusc; //number that are susceptible (the effective population of interest)
    int<lower = 1> nobs; // number of days observed
    array[nobs] real t;
    array[nobs] int I;
}

transformed data {
  array[0] real x_r;
  array[0] int x_i;
  }

parameters{
    array[2] real<lower = 0> theta; // model parameters 
    real<lower = 0, upper = 1> S0;  // initial fraction of susceptible individuals
    real phi;
  }

transformed parameters{
    array[nobs, 3] real ln; // solution from the ODE solver
    array[3] real ln_init;     // initial conditions for fractions

    ln_init[1] = S0; //S, ODE system is Nsusc normalized
    ln_init[2] = 1-S0;//1/Nsusc; //I
    ln_init[3] = 0; //R

    ln = integrate_ode_rk45(SIR, ln_init, t[1]-1, t, theta, x_r, x_i);
  }

model{
    //priors
    S0 ~ beta(2, 2); //some prior for between 0 and 1 fraction of the population
    for (i in 1:2){
        theta[i] ~ lognormal(0,1);
    }

    //likelihood
    for (i in 1:nobs){
        // target += poisson_lpmf(I[i]|ln[i,2]*Nsusc);  # I
        target += neg_binomial_2_lpmf(I[i]|ln[i, 2] * Nsusc, phi);
        }
  }

