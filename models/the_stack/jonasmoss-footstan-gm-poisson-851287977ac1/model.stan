data {
  int<lower = 0> N_MATCHES; // Number of matches.
  int<lower = 0> N_TEAMS;   // Number of teams.
  array[N_MATCHES, 4] int y;      // Data.
}

parameters {
  array[N_TEAMS] real<lower = 0> attack;
  array[N_TEAMS] real<lower = 0> defense;
  real baseline;
  real<lower = 0> homefield;
}

model {

  // Prior.

  baseline ~ normal(0, 1);
  homefield ~ normal(0, 1) T[0, ];

  for(i in 1:N_TEAMS) {
    attack[i] ~ normal(0, 1) T[0, ];
    defense[i] ~ normal(0, 1) T[0, ];
  }

  // Likelihood.
  for(i in 1:N_MATCHES) {
    int home_index = y[i, 3];
    int away_index = y[i, 4];
    real home_attack  = attack[home_index];
    real home_defense = defense[home_index];
    real away_attack  = attack[away_index];
    real away_defense = defense[away_index];
    y[i, 1] ~ poisson_log(baseline + homefield + home_attack - away_defense);
    y[i, 2] ~ poisson_log(baseline + away_attack - home_defense);
  }

}

