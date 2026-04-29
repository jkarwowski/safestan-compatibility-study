// ForestDB translation: Schelling Coordination Game
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
  beta ~ lognormal(0, 0.75);
  chosen_action ~ categorical_logit(beta * utility);
}
generated quantities {
  simplex[A] action_prob = softmax(beta * utility);
}
