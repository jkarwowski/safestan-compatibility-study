data {
  int N;
  array[N] int n_redcards;
  array[N] int n_games;
  vector[N] rating;
}
transformed data {
  vector[2] beta_mu;
  vector<lower=0>[2] beta_sigma;
  beta_mu[1] = 0;
  beta_mu[2] = 0;
  beta_sigma[1] = 10;
  beta_sigma[2] = 1;
}
parameters {
  vector[2] beta;
}
model {
  beta ~ normal(beta_mu, beta_sigma);
  
  n_redcards ~ binomial_logit(n_games, beta[1] + beta[2] * rating);
}
