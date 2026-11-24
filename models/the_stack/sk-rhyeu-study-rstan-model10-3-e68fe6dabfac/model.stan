data {
  int N;  // num of players
  int G;  // num of games
  array[G, 2] int<lower=1, upper=N> LW;  // loser and winner of each game
}

parameters {
  array[G] ordered[2] performance;
  real b;
}

transformed parameters {
  array[N] real mu;
  mu[1] = 0;
  mu[2] = b;
}

model {
  for (g in 1:G)
    for (i in 1:2)
      performance[g, i] ~ normal(mu[LW[g, i]], 1);
}
