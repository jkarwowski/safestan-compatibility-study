data {
  int<lower=1> N_predict;
  array[N_predict] real f;
  real<lower=0> sigma;
}

parameters {}
model {}

generated quantities {
  array[N_predict] real y_predict = normal_rng(f, sigma);
}
