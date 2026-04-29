data {
  int<lower=0> K;                       // Number of contexts
  int<lower=0> N;                       // Number of observations
  vector[N] y;                          // Observations
  array[N] int<lower=1, upper=K> context_idx; // Context assignments

  vector<lower=0, upper=1>[K] w;        // Partial centering parameters

  real<lower=0> sigma;                  // Measurement variability
}

parameters {
  vector[K] theta_tilde;
  vector<lower=0>[K] lambda;
  real<lower=0> tau;
}

transformed parameters {
  vector[K] theta;
  for (k in 1:K)
    theta[k] = pow(lambda[k] * tau, 1 - w[k]) * theta_tilde[k];
}

model {
  vector[K] theta_tilde_scale;

  lambda ~ cauchy(0, 1);
  tau ~ normal(0, 0.1);

  for (k in 1:K)
    theta_tilde_scale[k] = pow(lambda[k] * tau, w[k]);
  theta_tilde ~ normal(0, theta_tilde_scale);

  // Observational model
  y ~ normal(theta[context_idx], sigma);
}
