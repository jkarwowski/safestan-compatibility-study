data {
  int Nobs; /* Number of observations */

  array[Nobs] real logLobs; /* natural log of luminosity observed. */
  array[Nobs] real sigma_logL; /* Uncertainty on each measurement. */

  array[Nobs] real Tobs; /* Observed temperature. */
  array[Nobs] real sigma_Tobs; /* Temperature uncertainty */
}

parameters {
  real<lower=0,upper=15> beta; /* Power-law slope L = T^beta */
  real<lower=0> gamma; /* p(T) ~ T^-(gamma+1), appropriate for a power-law IMF. */
  real<lower=0> sigma_scatter;
  array[Nobs] real<lower=0.8, upper=3> Ttrue;  /* True temperature */
  array[Nobs] real logLtrue;
}

transformed parameters {
  array[Nobs] real Ltrue;
  real alpha; /* Corresponds to the exponent in the IMF. */

  Ltrue = exp(logLtrue);
  alpha = 1.0 + 3.0*gamma/8.0;
}

model {
  /* Uniform prior on beta between limits. */
  /* Broad, Cauchy prior on sigma_scatter, with scale 0.1 */
  sigma_scatter ~ cauchy(0, 0.1);

  /* Pareto distribution for Ttrue

  In stan, pareto(xmin, alpha) gives a distribution of

  x ~ alpha xmin^alpha / x^(alpha+1)

   */
  Ttrue ~ pareto(0.8, gamma);

  /* Scatter in the relation: */
  for (i in 1:Nobs) {
    logLtrue[i] ~ normal(beta*log(Ttrue[i]), sigma_scatter);
  }

  Tobs ~ normal(Ttrue, sigma_Tobs);
  logLobs ~ normal(logLtrue, sigma_logL);
}
