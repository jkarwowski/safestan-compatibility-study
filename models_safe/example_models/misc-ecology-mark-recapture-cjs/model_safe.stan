/*
 * Cormack-Jolly-Server (CJS) model.
 *
 * SafeStan-compatible rewrite: the scored portions of the aggregated
 * capture-history counts are represented as two multinomial observations.
 */
data {
  int<lower=0> history_noinfo;
  array[4] int<lower=0> history_first1;
  array[2] int<lower=0> history_first2;
}
parameters {
  array[2] real<lower=0, upper=1> phi; // phi[t] survival from t to t+1
  array[3] real<lower=0, upper=1> p; // p[t]   probability of capture at t+1
}
transformed parameters {
  // chi[t] probability a sighting at t is last sighting
  array[3] real<lower=0, upper=1> chi;
  chi[3] = 1;
  chi[2] = (1 - phi[2]) + phi[2] * (1 - p[3]);
  chi[1] = (1 - phi[1]) + phi[1] * (1 - p[2]) * chi[2];
}
model {
  vector[4] theta_first1;
  vector[2] theta_first2;

  phi ~ uniform(0, 1);
  p ~ uniform(0, 1);

  theta_first1[1] = chi[1];
  theta_first1[2] = phi[1] * (1 - p[2]) * phi[2] * p[3];
  theta_first1[3] = phi[1] * p[2] * chi[2];
  theta_first1[4] = phi[1] * p[2] * phi[2] * p[3];

  theta_first2[1] = chi[2];
  theta_first2[2] = phi[2] * p[3];

  history_first1 ~ multinomial(theta_first1);
  history_first2 ~ multinomial(theta_first2);
}
generated quantities {
  real<lower=0, upper=1> beta3;
  beta3 = phi[2] * p[3];
}
