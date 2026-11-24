data {
  int<lower = 0> N_MATCHES;             // Number of matches.
  int<lower = 0> N_TEAMS;               // Number of teams.
  array[N_MATCHES, 4] int y;                  // Data.
  array[N_MATCHES] real<lower = 0> difftimes; // Vector of time since games.
}

parameters {

  array[N_TEAMS] real attack;
  array[N_TEAMS] real defense;
  real baseline;
  real homefield;
  array[N_MATCHES] real home_attacks;
  array[N_MATCHES] real away_attacks;
  array[N_MATCHES] real home_defenses;
  array[N_MATCHES] real away_defenses;

  real <lower = 0> alpha;
  real <lower = 0> beta;
  real <lower = 0> gamma;

}

model {

  // Prior.

  baseline ~ normal(0, 1);
  homefield ~ normal(0, 1);
  attack ~ normal(0, 1);
  defense ~ normal(0, 1);

  // Parameters for the inverse logistic.
  alpha ~ exponential(1);
  beta ~ exponential(1);
  gamma ~ exponential(1);

  // Likelihood.
  for(i in 1:N_MATCHES) {

    int home_index = y[i, 3];
    int away_index = y[i, 4];
    real current_sd =  (inv_logit(gamma*difftimes[i]) - 0.5)*beta + alpha;

    home_attacks[i] ~ normal(attack[home_index], current_sd);
    away_attacks[i] ~ normal(attack[away_index], current_sd);
    home_defenses[i] ~ normal(defense[home_index], current_sd);
    away_defenses[i] ~ normal(defense[away_index], current_sd);

    y[i, 1] ~ poisson_log(baseline + homefield + home_attacks[i] - away_defenses[i]);
    y[i, 2] ~ poisson_log(baseline + away_attacks[i] - home_defenses[i]);
  }

}

