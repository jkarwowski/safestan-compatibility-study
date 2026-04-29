data {
  int<lower=0> n_dogs;
  int<lower=0> n_trials;
  array[n_dogs, n_trials] int<lower=0, upper=1> y;
  array[n_dogs * n_trials] int<lower=0, upper=1> y_safestan_flat;
}
transformed data {
  int<lower=0> J = n_dogs;
  int<lower=0> T = n_trials;
  matrix<lower=0>[J, T] prev_shock;
  matrix<lower=0>[J, T] prev_avoid;
  
  for (j in 1 : J) {
    prev_shock[j, 1] = 0;
    prev_avoid[j, 1] = 0;
    for (t in 2 : T) {
      prev_shock[j, t] = prev_shock[j, t - 1] + y[j, t - 1];
      prev_avoid[j, t] = prev_avoid[j, t - 1] + 1 - y[j, t - 1];
    }
  }
}
parameters {
  real<lower=0, upper=1> a;
  real<lower=0, upper=1> b;
}
model {
  a ~ uniform(0, 1);
  b ~ uniform(0, 1);
  {
    array[n_dogs * n_trials] real p_safestan_flat;
    
    for (j in 1 : J) {
      for (t in 1 : T) {
        p_safestan_flat[(j - 1) * T + t] = a ^ prev_shock[j, t] * b ^ prev_avoid[j, t];
      }
    }
    y_safestan_flat ~ bernoulli(p_safestan_flat);
  }
}
generated quantities {
  array[n_dogs, n_trials] int<lower=0, upper=1> y_rep;
  {
    real prev_shock_rep;
    real prev_avoid_rep;
    real p_rep;
    for (j in 1 : J) {
      prev_shock_rep = 0;
      prev_avoid_rep = 0;
      y_rep[j, 1] = 1;
      for (t in 2 : T) {
        prev_shock_rep = prev_shock_rep + y_rep[j, t - 1];
        prev_avoid_rep = prev_avoid_rep + 1 - y_rep[j, t - 1];
        p_rep = a ^ prev_shock_rep * b ^ prev_avoid_rep;
        y_rep[j, t] = bernoulli_rng(p_rep);
      }
    }
  }
}
