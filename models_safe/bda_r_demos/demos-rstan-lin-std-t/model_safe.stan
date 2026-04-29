// Linear student-t model
data {
  int<lower=0> N; // number of data points
  vector[N] x; // covariate / predictor
  vector[N] y; // target
  vector[N] y_safestan_copy; // deterministic copy of y for pre-observation standardization constants
  real xpred; // new covariate value to make predictions
}
transformed data {
  // deterministic transformations of context data
  vector[N] x_std = (x - mean(x)) / sd(x);
  real y_mean = mean(y_safestan_copy);
  real y_sd = sd(y_safestan_copy);
  real xpred_std = (xpred - mean(x)) / sd(x);
}
parameters {
  real alpha; // intercept
  real beta; // slope
  real<lower=0> sigma_std; // standard deviation is constrained to be positive
  real<lower=1> nu; // degrees of freedom is constrained >1
}
transformed parameters {
  // deterministic transformation of parameters and context data
  vector[N] mu_std = alpha + beta * x_std; // linear model on standardized scale
}
model {
  alpha ~ normal(0, 1); // weakly informative prior (given standardized data)
  beta ~ normal(0, 1); // weakly informative prior (given standardized data)
  sigma_std ~ normal(0, 1); // weakly informative prior (given standardized data)
  nu ~ gamma(2, 0.1); // Juárez and Steel(2010)
  y ~ student_t(nu, mu_std * y_sd + y_mean, sigma_std * y_sd); // observation model / likelihood
}
generated quantities {
  // transform to the original data scale
  vector[N] mu = mu_std * y_sd + y_mean;
  real<lower=0> sigma = sigma_std * y_sd;
  // sample from the predictive distribution
  real ypred = student_t_rng(nu,
                             (alpha + beta * xpred_std) * y_sd + y_mean,
                             sigma_std * y_sd);
  // compute log predictive densities to be used for LOO-CV
  // to make appropriate comparison to other models, this log density is computed
  // using the original data scale (y, mu, sigma)
  vector[N] log_lik;
  for (i in 1 : N) {
    log_lik[i] = student_t_lpdf(y[i] | nu, mu[i], sigma);
  }
}
