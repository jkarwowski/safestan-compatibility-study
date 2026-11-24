data {
  int<lower = 1> N_games;
  int<lower = 2> N_teams;
  array[N_games] real<lower = 0> away_points;
  array[N_games] real<lower = 0> home_points;
  array[N_games] int<lower = 0> overtime;
  array[N_games] int<lower = 1, upper = N_teams> away_team_id;
  array[N_games] int<lower = 1, upper = N_teams> home_team_id;
}

transformed data {
  array[N_games] real score_difference;
  for (n in 1:N_games) {
    if (overtime[n] > 0) {
      score_difference[n] = 0;
    } else {
      score_difference[n] = away_points[n] - home_points[n];
    }
  }
}

parameters {
  array[N_teams] real team_skill;
  real<lower = 0> scale;
  array[N_teams] real home_court_advantage_raw;
  real mu_home;
  real<lower = 0> sigma_home;
}

transformed parameters {
  array[N_teams] real home_court_advantage;
  vector[N_games] skill_difference;
  // non-centered parametrization for hierarchical prior
  for (n in 1:N_teams) {
    home_court_advantage[n] = mu_home + home_court_advantage_raw[n] * sigma_home;
  }

  for (n in 1:N_games) {
    skill_difference[n] = team_skill[away_team_id[n]] - team_skill[home_team_id[n]];
  }
}

model {
  // priors
  scale ~ normal(0, 1);
  team_skill ~ normal(0, 4);
  home_court_advantage_raw ~ normal(0, 1);
  mu_home ~ normal(0, 3);
  sigma_home ~ normal(0, 3);
  
  // likelihood
  for (n in 1:N_games) {
    score_difference[n] ~ normal(skill_difference[n] - home_court_advantage[home_team_id[n]], scale);
  }
}

generated quantities {
  array[N_games] real score_difference_rep;
  for (n in 1:N_games) {
    score_difference_rep[n] = normal_rng(skill_difference[n] - home_court_advantage[home_team_id[n]], scale);
  }
}
