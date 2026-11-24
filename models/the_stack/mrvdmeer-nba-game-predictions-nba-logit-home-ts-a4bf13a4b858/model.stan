data {
  int<lower = 1> N_games;
  int<lower = 2> N_teams;
  int<lower = 1> N_games_per_team;
  array[N_games] int<lower = 0, upper = 1> home_win;
  array[N_games] int<lower = 1, upper = N_teams> away_team_id;
  array[N_games] int<lower = 1, upper = N_teams> home_team_id;
}

transformed data {
  // counters count the nth game in the season
  // for the away and home teams
  array[N_games] int<lower = 1, upper = N_games_per_team> away_counter;
  array[N_games] int<lower = 1, upper = N_games_per_team> home_counter;
  array[N_teams] int<lower = 0, upper = N_games_per_team> position = rep_array(0, N_teams);
  for (n in 1:N_games) {
    position[away_team_id[n]] += 1;
    position[home_team_id[n]] += 1;
    away_counter[n] = position[away_team_id[n]];
    home_counter[n] = position[home_team_id[n]];
  }
}

parameters {
  array[N_teams, N_games_per_team] real team_skill_raw; // for non-centered parametrization
  real<lower = 0> init_scale;
  real<lower = 0> update_scale;
  real home_court_advantage;
}

transformed parameters {
  array[N_teams, N_games_per_team] real team_skill;
  vector[N_games] logit_prob_home_win;
  
  for (n in 1:N_teams) {
    team_skill[n, 1] = init_scale * team_skill_raw[n, 1];
    for (i in 2:N_games_per_team) {
      team_skill[n, i] = team_skill[n, i - 1] + update_scale * team_skill_raw[n, i];
    }
  }
  // this code calculates the skill difference at the time of the game
  // since away team and home team might have already played a different
  // number of games this complicated setup with the counters is necessary.
  for (n in 1:N_games){
    logit_prob_home_win[n] = team_skill[home_team_id[n], home_counter[n]]
    - team_skill[away_team_id[n], away_counter[n]] + home_court_advantage;
  }
}

model {
  // priors
  init_scale ~ normal(0,1);
  update_scale ~ normal(0, 1);
  home_court_advantage ~ normal(0.3, 0.2);
  
  for (n in 1:N_teams) {
    team_skill_raw[n, :] ~ normal(0, 1);
  }
  
  // likelihood
  home_win ~ bernoulli_logit(logit_prob_home_win);
}

generated quantities {
  array[N_games] int home_win_rep;
  for (n in 1:N_games) {
    home_win_rep[n] = bernoulli_logit_rng(logit_prob_home_win[n]);
  }
}
