// ForestDB translation: Monty Hall Problem
data {
  int<lower=1> S;
  int<lower=1> N;
  vector<lower=0>[S] prior_concentration;
  matrix[N, S] log_lik;
}
parameters {
  simplex[S] state_prob;
}
model {
  state_prob ~ dirichlet(prior_concentration);
  for (n in 1:N) {
    vector[S] lp;
    for (s in 1:S) {
      lp[s] = log(state_prob[s]) + log_lik[n, s];
    }
    target += log_sum_exp(lp);
  }
}
generated quantities {
  int<lower=1, upper=S> latent_state = categorical_rng(state_prob);
}
