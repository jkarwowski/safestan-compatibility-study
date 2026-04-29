data {
  int<lower=0> n_trials;
  int<lower=0> n_dogs;
  array[n_dogs, n_trials] int<lower=0, upper=1> y;
  array[n_dogs * n_trials] int<lower=0, upper=1> y_flat;
}
transformed data {
  vector[2] beta_lower;
  vector[2] beta_upper;
  
  beta_lower[1] = -100;
  beta_lower[2] = 0;
  beta_upper[1] = 0;
  beta_upper[2] = 100;
}
parameters {
  vector[2] beta;
}
transformed parameters {
  matrix[n_dogs, n_trials] n_avoid;
  matrix[n_dogs, n_trials] n_shock;
  matrix[n_dogs, n_trials] p;
  array[n_dogs * n_trials] real p_safestan;
  
  for (j in 1 : n_dogs) {
    n_avoid[j, 1] = 0;
    n_shock[j, 1] = 0;
    for (t in 2 : n_trials) {
      n_avoid[j, t] = n_avoid[j, t - 1] + 1 - y[j, t - 1];
      n_shock[j, t] = n_shock[j, t - 1] + y[j, t - 1];
    }
    for (t in 1 : n_trials) {
      p[j, t] = inv_logit(beta[1] * n_avoid[j, t] + beta[2] * n_shock[j, t]);
      p_safestan[(j - 1) * n_trials + t] = p[j, t];
    }
  }
}
model {
  beta ~ uniform(beta_lower, beta_upper);
  y_flat ~ bernoulli(p_safestan);
}
