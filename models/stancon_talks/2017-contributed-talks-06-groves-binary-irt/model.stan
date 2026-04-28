data {
  // numbers of things
  int<lower=1> R;
  int<lower=1> I;
  int<lower=1> S;
  // data
  array[R] int<lower=1,upper=I> item;
  array[R] int<lower=1,upper=S> subject;
  array[R] int<lower=0,upper=1> grade;
}
parameters {
  // parameters
  vector[S] ability;
  vector[I] difficulty;
  // hyperparameters
  real mu_difficulty;
  real<lower=0> sigma_difficulty;
  real<lower=0> sigma_ability;
}
model {
  // priors
  ability ~ normal(0, sigma_ability);
  difficulty ~ normal(0, sigma_difficulty);
  mu_difficulty ~ cauchy(0, 5);
  // data model
  grade ~ bernoulli_logit(ability[subject] - difficulty[item] - mu_difficulty);
}
