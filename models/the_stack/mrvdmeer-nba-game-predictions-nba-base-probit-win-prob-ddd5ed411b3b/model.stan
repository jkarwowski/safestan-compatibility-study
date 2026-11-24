data {
  int<lower = 1> N_games;
  int<lower = 2> N_teams;
  array[N_games] int<lower = 0, upper = 1> home_win;
  array[N_games] int<lower = 1, upper = N_teams> away_team_id;
  array[N_games] int<lower = 1, upper = N_teams> home_team_id;
}

parameters {
  array[N_teams] real team_skill;
}

transformed parameters {
  vector[N_games] prob_home_win;
  
  for (n in 1:N_games) {
    prob_home_win[n] = Phi(team_skill[home_team_id[n]] - team_skill[away_team_id[n]]);
  }
}

model {
  // priors
  team_skill ~ normal(0, 1);
  
  // likelihood
  home_win ~ bernoulli(prob_home_win);
}

generated quantities {
  array[N_games] real home_win_rep;
  for (n in 1:N_games) {
    home_win_rep[n] = bernoulli_rng(prob_home_win[n]);
  }
}
