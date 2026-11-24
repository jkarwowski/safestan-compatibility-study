data {
  int T;                                // Sample size
  int<lower=1> K;                       // Number of seasonal vectors
  array[T] real t;                            // Day
  array[T] real cap;                          // Capacities
  array[T] real y;                            // Time-series
  int S;                                // Number of changepoints
  array[T, S] real A;                   // Split indicators
  array[S] real t_change;                 // Index of changepoints
  array[T, K] real X;                    // season vectors
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
  array[S + 1] real k_s;                 // actual rate in each segment
  real m_pr;

  // Compute the rate in each segment
  k_s[1] = k;
  for (i in 1:S) {
    k_s[i + 1] = k_s[i] + delta[i];
  }

  // Piecewise offsets
  m_pr = m; // The offset in the previous segment
  for (i in 1:S) {
    gamma[i] = (t_change[i] - m_pr) * (1 - k_s[i] / k_s[i + 1]);
    m_pr = m_pr + gamma[i];  // update for the next segment
  }
}

model {
  array[T] real Y;

  //priors
  k ~ normal(0, 5);
  m ~ normal(0, 5);
  delta ~ double_exponential(0, tau);
  sigma_obs ~ normal(0, 0.1);
  beta ~ normal(0, sigma);

  // Likelihood
  for (i in 1:T) {
    Y[i] = cap[i] / (1 + exp(-(k + dot_product(A[i], delta)) * (t[i] - (m + dot_product(A[i], gamma))))) + dot_product(X[i], beta);
  }
  y ~ normal(Y, sigma_obs);
}
