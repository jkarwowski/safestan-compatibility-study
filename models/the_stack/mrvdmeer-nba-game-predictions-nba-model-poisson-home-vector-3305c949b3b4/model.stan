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
  array[N_teams] real<lower = 0> team_skill;
  array[N_teams] real home_court_advantage_raw;
  real mu_home;
  real<lower = 0> sigma_home;
}

transformed parameters {
  array[N_teams] real home_court_advantage;
  // non-centered parametrization for hierarchical prior
  for (n in 1:N_teams) {
    home_court_advantage[n] = mu_home + home_court_advantage_raw[n] * sigma_home;
  }
}

model {
  // priors
  team_skill ~ exponential(0.01);
  home_court_advantage_raw ~ normal(0, 1);
  mu_home ~ normal(0, 3);
  sigma_home ~ normal(0, 3);

  // likelihood
  for (n in 1:N_games) {
    away_points[n] ~ poisson(team_skill[away_team_id[n]]);
    home_points[n] ~ poisson(team_skill[home_team_id[n]] + home_court_advantage[home_team_id[n]]);
  }
}

generated quantities {
  array[N_games] int away_score_rep;
  array[N_games] int home_score_rep;
  array[N_games] int score_difference_rep;
  for (n in 1:N_games) {
    away_score_rep[n] = poisson_rng(team_skill[away_team_id[n]]);
    home_score_rep[n] = poisson_rng(team_skill[home_team_id[n]] + home_court_advantage[home_team_id[n]]);
    score_difference_rep[n] = away_score_rep[n] - home_score_rep[n];
  }
}
