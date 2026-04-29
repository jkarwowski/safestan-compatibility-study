data {
  int<lower=0> n_dogs;
  int<lower=0> n_trials;
  array[n_dogs, n_trials] int<lower=0, upper=1> y;
  array[n_dogs * n_trials] int<lower=0, upper=1> y_flat_safestan;
}
parameters {
  real<lower=0, upper=100> sigma_b1;
  real<lower=0, upper=100> sigma_b2;
  array[n_dogs] vector[2] beta_neg;
  real<lower=-1, upper=1> rho_b;
  vector[2] mu_beta;
}
model {
  vector[n_dogs] beta1;
  vector[n_dogs] beta2;
  matrix[n_dogs, n_trials] n_avoid;
  matrix[n_dogs, n_trials] n_shock;
  array[n_dogs * n_trials] real p_flat_safestan;
  matrix[2, 2] Sigma_b;
  
  sigma_b1 ~ uniform(0, 100);
  sigma_b2 ~ uniform(0, 100);
  rho_b ~ uniform(-1, 1);
  mu_beta ~ normal(0, 100);
  
  Sigma_b[1, 1] = pow(sigma_b1, 2);
  Sigma_b[2, 2] = pow(sigma_b2, 2);
  Sigma_b[1, 2] = rho_b * sigma_b1 * sigma_b2;
  Sigma_b[2, 1] = Sigma_b[1, 2];
  
  beta_neg ~ multi_normal_prec(mu_beta, Sigma_b);
  
  for (j in 1 : n_dogs) {
    n_avoid[j, 1] = 0;
    n_shock[j, 1] = 0;
    beta1[j] = -exp(beta_neg[j][1]);
    beta2[j] = -exp(beta_neg[j][2]);
    for (t in 2 : n_trials) {
      n_avoid[j, t] = n_avoid[j, t - 1] + 1 - y[j, t - 1];
      n_shock[j, t] = n_shock[j, t - 1] + y[j, t - 1];
    }
    for (t in 1 : n_trials) {
      p_flat_safestan[(j - 1) * n_trials + t] = inv_logit(beta1[j] * n_avoid[j, t] + beta2[j] * n_shock[j, t]);
    }
  }
  y_flat_safestan ~ bernoulli(p_flat_safestan);
}
