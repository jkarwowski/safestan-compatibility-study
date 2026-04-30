data {
  int<lower=0> n_dogs;
  int<lower=0> n_trials;
  int<lower=1> N_patterns;
  array[N_patterns] int<lower=0> prev_shock_count;
  array[N_patterns] int<lower=0> prev_avoid_count;
  array[N_patterns] int<lower=0> y_trials;
  array[N_patterns] int<lower=0> y_successes;
}
transformed data {
  int<lower=0> J = n_dogs;
  int<lower=0> T = n_trials;
}
parameters {
  real<lower=0, upper=1> a;
  real<lower=0, upper=1> b;
}
model {
  vector[N_patterns] p;

  a ~ uniform(0, 1);
  b ~ uniform(0, 1);
  for (i in 1:N_patterns) {
    p[i] = a ^ prev_shock_count[i] * b ^ prev_avoid_count[i];
  }
  y_successes ~ binomial(y_trials, p);
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
