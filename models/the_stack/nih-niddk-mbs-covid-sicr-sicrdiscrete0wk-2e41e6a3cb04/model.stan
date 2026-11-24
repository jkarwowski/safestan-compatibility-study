// SICRdiscrete.stan
// Discrete SICR model


data {
      int<lower=1> n_obs;
      int<lower=0> n_weeks;      // number of weeks
      int n_total;               // total number of weeks simulated, n_total-n_weekss is weeks beyond last data point
      int<lower=1> n_ostates;   // number of observed states
      array[n_weeks, n_ostates] int y;     // data, per-week-tally [cases,recovered,death]
      real tm;                    // start day of mitigation
      array[n_total] real ts;             // time points that were observed + projected
  }

transformed data {

}


parameters {
array[n_weeks] real<lower=0> beta;             // infection rate
array[n_weeks] real<lower=0> alpha;
array[n_weeks] real<lower=0> sigd;
array[n_weeks] real<lower=0> sigc;
array[n_weeks] real<lower=0> sigr;
real<lower=0> sigmau;             // uninfected rate
//real<lower=0> sigmac0;             // case rate
//real<lower=0> sigmac1;             // case rate
real<lower=0> sigmar0;             // recovery rate
real<lower=0> sigmar1;             // recovery rate
real<lower=0> sigmar2;

}

transformed parameters {

  array[n_weeks] real dI;
  array[n_weeks] real dC;
  array[n_weeks] real dR;
  array[n_weeks] real dD;

{
  array[n_weeks] real sigmad;
  array[n_weeks] real sigmar;
  array[n_weeks] real sigmac;
  real C;
  real I;
  array[n_weeks] real Cd;

  C = 0;
  I = 0;
  for (i in 1:n_weeks){
    sigmac[i] = sigc[i];
    sigmar[i] = sigr[i];
    sigmad[i] = sigd[i];
    I *= exp(beta[i] - sigmac[i] - sigmau);
    I += alpha[i];
    dC[i] = sigmac[i]*I;
    C += dC[i];
    C *= exp(-(sigmar[i]+sigmad[i]));
    Cd[i] = C;
    dI[i] = (exp(beta[i])-1)*I + alpha[i];
    dR[i] = sigmar[i]*C;
    dD[i] = sigmad[i]*C;
    /*
    if (i > 2)
      dD[i] = sigmad[i]*Cd[i-2];
    else
      dD[i] = sigmad[i]*C;
    */
  }
  }
}

model {

    sigmau ~ exponential(1.);

    for (i in 1:n_weeks){
      alpha[i] ~ exponential(10.);
      beta[i] ~ normal(1.,.5);
      sigd[i] ~ exponential(5.);
      sigc[i] ~ exponential(.5);
      sigr[i] ~ exponential(2.);
      target += poisson_lpmf(y[i,1] | dC[i]);
      target += poisson_lpmf(y[i,2] | dR[i]);
      target += poisson_lpmf(y[i,3] | dD[i]);
    }
    for (i in 2:n_weeks-1){
      target += normal_lpdf(beta[i+1]-beta[i] | 0, .1);
      target += normal_lpdf(beta[i+1]-2*beta[i]+beta[i-1] | 0, .1);
      target += normal_lpdf((alpha[i+1]-alpha[i])/(alpha[i+1]+alpha[i]) | 0, .02);
      target += normal_lpdf((alpha[i+1]-2*alpha[i]+alpha[i-1])/(alpha[i+1]+alpha[i]) | 0, .02);
      target += normal_lpdf(sigc[i+1]-sigc[i] | 0, .1);
      target += normal_lpdf(sigc[i+1]-2*sigc[i]+sigd[i-1] | 0, .1);
      target += normal_lpdf(sigd[i+1]-sigd[i] | 0, .1);
      target += normal_lpdf(sigd[i+1]-2*sigd[i]+sigd[i-1] | 0, .1);
    }
}

// generated quantities

generated quantities {

    array[n_weeks] real car;
    array[n_weeks] real ifr;
    array[n_weeks] real Rt;
    array[n_weeks, n_ostates] int y_proj;
    array[n_weeks, n_ostates] real llx;
    real ll_ = 0; // log-likelihood for model

    real R0 = beta[1]/(sigc[1]+sigmau);

    {
      real C_cum;
      real I_cum;
      real D_cum;

      C_cum = 0;
      I_cum = 0;
      D_cum = 0;

      for (i in 1:n_weeks) {
        C_cum += dC[i];
        I_cum += dI[i];
        D_cum += dD[i];
        car[i] = C_cum/I_cum;
        ifr[i] = D_cum/I_cum;
        Rt[i] = beta[i]/(sigc[i]+sigmau);
        y_proj[i,1] = poisson_rng(min([dC[i],1e8]));
        y_proj[i,2] = poisson_rng(min([dR[i],1e8]));
        y_proj[i,3] = poisson_rng(min([dD[i],1e8]));
        llx[i,1] = poisson_lpmf(y[i,1] | min([dC[i]/7,1e8]));
        llx[i,2] = poisson_lpmf(y[i,2] | min([dR[i]/7,1e8]));
        llx[i,3] = poisson_lpmf(y[i,3] | min([dD[i]/7,1e8]));
        ll_ += llx[i,1] + llx[i,2] + llx[i,3];
      }
    }

}
