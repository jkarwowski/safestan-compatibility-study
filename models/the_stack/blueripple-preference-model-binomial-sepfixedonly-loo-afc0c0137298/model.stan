data {
int<lower = 0> G; // number of cells
  int<lower = 1> J_state; // number of states
  array[G] int<lower = 1, upper = J_state> state;
  int<lower = 1> K; // number of cols in predictor matrix
  matrix[G, K] X;
  array[G] int<lower = 0> D_votes;
  array[G] int<lower = 0> Total_votes;
  int<lower = 0> M;
  array[M] int<lower = 0> predict_State;
  matrix[M, K] predict_X;
}
parameters {
real alpha;
  vector[K] beta;
}
model {
D_votes ~ binomial_logit(Total_votes, alpha + X * beta);
}
generated quantities {
vector[G] log_lik;
  for (g in 1:G) {
    log_lik[g] =  binomial_logit_lpmf(D_votes[g] | Total_votes[g], alpha + X[g] * beta);
  }
}
