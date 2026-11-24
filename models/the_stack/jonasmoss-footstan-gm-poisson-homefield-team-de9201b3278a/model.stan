data {
  int<lower = 0> N_MATCHES; // Number of matches.
  int<lower = 0> N_TEAMS;   // Number of teams.
  array[N_MATCHES, 4] int y;      // Data.
}

parameters {
  array[N_TEAMS] real attack;
  array[N_TEAMS] real defense;
  real baseline;
  array[N_TEAMS] real homefields;
  real homefield_mean;
  real homefield_sd;
}

model {

  // Prior.

  baseline ~ normal(0, 1);
  homefield_mean ~ normal(0, 1);
  homefield_sd ~ exponential(1);
  homefields ~ normal(homefield_mean, homefield_sd);
  attack ~ normal(0, 1);
  defense ~ normal(0, 1);

  // Likelihood.
  for(i in 1:N_MATCHES) {
    int home_index = y[i, 3];
    int away_index = y[i, 4];
    real home_attack  = attack[home_index];
    real home_defense = defense[home_index];
    real away_attack  = attack[away_index];
    real away_defense = defense[away_index];
    y[i, 1] ~ poisson_log(baseline + homefields[home_index] + home_attack - away_defense);
    y[i, 2] ~ poisson_log(baseline + away_attack - home_defense);
  }

}

