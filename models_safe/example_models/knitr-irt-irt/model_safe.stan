data {
  int<lower=1> I; // // items
  int<lower=1> J; // // students
  array[I, J] int<lower=0, upper=1> y; // boolean correctness of student j on item i for n
  array[I * J] int<lower=0, upper=1> y_safestan_flat;
}
parameters {
  vector[J] alpha; // ability for student j
  vector[I] beta; // difficulty for item i
  vector<lower=0>[I] delta; // discriminativeness for item i
}
model {
  vector[I * J] eta;

  alpha ~ normal(0, 1);
  beta ~ normal(0, 5);
  delta ~ gamma(2, 2);

  for (i in 1 : I) {
    for (j in 1 : J) {
      eta[(i - 1) * J + j] = delta[i] * (alpha[j] - beta[i]);
    }
  }

  y_safestan_flat ~ bernoulli_logit(eta);
}
