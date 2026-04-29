data {
  int<lower=0> n_dogs;
  int<lower=0> n_trials;
  array[n_dogs, n_trials] int<lower=0, upper=1> y;
  array[n_dogs * n_trials] int<lower=0, upper=1> y_safestan_flat;
}
parameters {
  vector[3] beta;
}
transformed parameters {
  matrix[n_dogs, n_trials] n_avoid;
  matrix[n_dogs, n_trials] n_shock;
  matrix[n_dogs, n_trials] p;
  vector[n_dogs * n_trials] p_safestan_flat;
  
  for (j in 1 : n_dogs) {
    n_avoid[j, 1] = 0;
    n_shock[j, 1] = 0;
    for (t in 2 : n_trials) {
      n_avoid[j, t] = n_avoid[j, t - 1] + 1 - y[j, t - 1];
      n_shock[j, t] = n_shock[j, t - 1] + y[j, t - 1];
    }
    for (t in 1 : n_trials) {
      p[j, t] = beta[1] + beta[2] * n_avoid[j, t] + beta[3] * n_shock[j, t];
      p_safestan_flat[(j - 1) * n_trials + t] = p[j, t];
    }
  }
}
model {
  beta ~ normal(0, 100);
  y_safestan_flat ~ bernoulli_logit(p_safestan_flat);
}
