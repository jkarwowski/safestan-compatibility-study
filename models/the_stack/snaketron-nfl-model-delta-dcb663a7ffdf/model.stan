data {
  int<lower=0> N;
  int<lower=0> Nt; // total number teams
  array[N] real y; // scores
  array[N] int x; // team id
  array[N] int home; //1 = home, -1 = away
  
  int N_pred;
  array[N_pred, 2] int x_pred;
}

parameters {
  vector [Nt] score_mu;
  vector [Nt] score_home;
  real <lower = 0> score_sd;
}

model {
  for(i in 1:N) {
    y[i] ~ normal(score_mu[x[i]] + score_home[x[i]]*home[i], score_sd);
  }
  
  score_mu ~ normal(0, 5);
  score_home ~ normal(0, 5);
  score_sd ~ cauchy(0, 1);
}

generated quantities {
  vector [N_pred] y_delta;
  
  for(i in 1:N_pred) {
    y_delta[i] = normal_rng(score_mu[x_pred[i, 1]] + score_home[x_pred[i, 1]]*1 , score_sd)-
    normal_rng(score_mu[x_pred[i, 2]] + score_home[x_pred[i, 2]]*(-1), score_sd);
  }
}
