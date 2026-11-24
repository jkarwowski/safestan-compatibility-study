data {
  int<lower = 1> N_games;
  int<lower = 2> N_teams;
  array[N_games] int<lower = 0> away_points;
  array[N_games] int<lower = 0> home_points;
  array[N_games] int<lower = 0> overtime;
  array[N_games] int<lower = 1, upper = N_teams> away_team_id;
  array[N_games] int<lower = 1, upper = N_teams> home_team_id;
}

transformed data {
}

parameters {
  array[N_teams] real<lower=0> team_skill;
  real home_court_advantage;
  real<lower=0> inv_precision;
}

transformed parameters {
  real precision = inv(inv_precision);
}

model {
  // priors
  team_skill ~ exponential(0.01);
  home_court_advantage ~ normal(0, 4);
  inv_precision ~ normal(0, 1);

  // likelihood
  for (n in 1:N_games) {
    away_points[n] ~ neg_binomial_2(team_skill[away_team_id[n]], precision);
    home_points[n] ~ neg_binomial_2(team_skill[home_team_id[n]] + home_court_advantage, precision);
  }
}

generated quantities {
  array[N_games] int away_score_rep;
  array[N_games] int home_score_rep;
  array[N_games] int score_difference_rep;
  for (n in 1:N_games) {
    away_score_rep[n] = neg_binomial_2_rng(team_skill[away_team_id[n]], precision);
    home_score_rep[n] = neg_binomial_2_rng(team_skill[home_team_id[n]] + home_court_advantage, precision);
    score_difference_rep[n] = away_score_rep[n] - home_score_rep[n];
  }
}
