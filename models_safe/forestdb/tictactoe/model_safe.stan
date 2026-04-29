// ForestDB translation: Tic-Tac-Toe
data {
  int<lower=1> A;
  int<lower=1> N;
  array[N] int<lower=1, upper=A> chosen_action;
  vector[A] utility;
}
parameters {
  real<lower=0> beta;
}
model {
  vector[A] logits;
  beta ~ lognormal(0, 0.75);
  logits = beta * utility;
  chosen_action ~ categorical_logit(logits);
}
generated quantities {
  simplex[A] action_prob = softmax(beta * utility);
}
