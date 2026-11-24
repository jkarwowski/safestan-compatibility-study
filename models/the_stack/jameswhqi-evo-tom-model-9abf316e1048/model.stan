data {
  int<lower=1> nt; // number of trials in total
  int<lower=1> ns; // number of subjects
  array[nt] int<lower=1,upper=ns> sid; // subject index for each trial
  array[nt] real psp; // payoff, self, predicted: average PAYOFF for the computer (SELF) for the row PREDICTED by the subject
  array[nt] real pop; // payoff, opponent, predicted
  array[nt] real psn; // payoff, self, non-predicted
  array[nt] real pon; // payoff, opponent, non-predicted
}

parameters {
  real<lower=0> alpha_gamma_alpha; // alpha parameter of the gamma distribution from which the softmax parameters are drawn
  real<lower=0> alpha_gamma_beta; // beta parameter of ...
  array[ns] real<lower=0> alpha; // softmax parameter for each subject

  real lambda_normal_mu; // mean of the normal distribution from which lambdas are drawn
  real<lower=0> lambda_normal_sigma; // sd of ...
  array[ns] real lambda; // lambda for each subject
}

model {
  array[nt] real log_odds; // log-odds that the computer chooses the predicted row (Bernoulli parameter)

  for (i in 1:nt) {
    real l = lambda[sid[i]]; // lambda
    real up = psp[i] + l * pop[i]; // utility for the predicted row
    real un = psn[i] + l * pon[i]; // utility for the non-predicted row
    
    log_odds[i] = (up - un) * alpha[sid[i]];
  }

  alpha_gamma_alpha ~ exponential(1);
  alpha_gamma_beta ~ exponential(1);
  alpha ~ gamma(alpha_gamma_alpha, alpha_gamma_beta);

  lambda_normal_sigma ~ exponential(1);
  lambda ~ normal(lambda_normal_mu, lambda_normal_sigma);
  
  1 ~ bernoulli_logit(log_odds);
}
