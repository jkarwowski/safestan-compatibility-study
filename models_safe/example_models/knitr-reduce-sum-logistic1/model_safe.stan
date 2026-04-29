data {
  int<lower=0> N;
  array[N] int<lower=0> n_redcards;
  array[N] int<lower=0> n_games;
  vector[N] rating;
  int<lower=1> grainsize;
}
transformed data {
  vector[2] beta_location;
  vector[2] beta_scale;

  beta_location[1] = 0;
  beta_location[2] = 0;
  beta_scale[1] = 10;
  beta_scale[2] = 1;
}
parameters {
  vector[2] beta;
}
model {
  beta ~ normal(beta_location, beta_scale);
  n_redcards ~ binomial_logit(n_games, beta[1] + beta[2] * rating);
}
