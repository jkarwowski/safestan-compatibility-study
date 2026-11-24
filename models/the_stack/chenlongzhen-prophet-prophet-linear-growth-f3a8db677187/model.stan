data {
  int T;                                // Sample size
  int<lower=1> K;                       // Number of seasonal vectors
  array[T] real t;                            // Day
  array[T] real y;                            // Time-series
  int S;                                // Number of changepoints
  array[T, S] real A;                   // Split indicators
  array[S] real t_change;                 // Index of changepoints
  array[T, K] real X;                // season vectors
  real<lower=0> sigma;              // scale on seasonality prior
  real<lower=0> tau;                  // scale on changepoints prior
}

parameters {
  real k;                            // Base growth rate
  real m;                            // offset
  array[S] real delta;                       // Rate adjustments
  real<lower=0> sigma_obs;               // Observation noise (incl. seasonal variation)
  array[K] real beta;                    // seasonal vector
}

transformed parameters {
  array[S] real gamma;                  // adjusted offsets, for piecewise continuity

  for (i in 1:S) {
    gamma[i] = -t_change[i] * delta[i];
  }
}

model {
  array[T] real Y;

  //priors
  k ~ normal(0, 5);
  m ~ normal(0, 5);
  delta ~ double_exponential(0, tau);
  sigma_obs ~ normal(0, 0.5);
  beta ~ normal(0, sigma);

  // Likelihood
  for (i in 1:T) {
    Y[i] = (dot_product(A[i], delta) + k) * t[i] + (dot_product(A[i], gamma) + m) + dot_product(X[i], beta);
  }
  y ~ normal(Y, sigma_obs);
}
