data {
  int Nobs; /* Number of observations */

  array[Nobs] real logLobs; /* natural log of luminosity observed. */
  array[Nobs] real sigma_logL; /* Uncertainty on each measurement. */

  array[Nobs] real Tobs; /* Observed temperature. */
  array[Nobs] real sigma_Tobs; /* Temperature uncertainty */
}

parameters {
  real<lower=0,upper=15> beta; /* Power-law slope L = T^beta */
  array[Nobs] real<lower=0.8, upper=3> Ttrue;  /* True temperature */
}

transformed parameters {
  array[Nobs] real Ltrue;
  array[Nobs] real logLtrue;

  for (i in 1:Nobs) {
    Ltrue[i] = Ttrue[i]^beta;
    logLtrue[i] = log(Ltrue[i]);
  }
}

model {
  /* Uniform prior on beta between limits. */
  /* Uniform prior on temperature between limits. */

  Tobs ~ normal(Ttrue, sigma_Tobs);
  logLobs ~ normal(logLtrue, sigma_logL);
}
