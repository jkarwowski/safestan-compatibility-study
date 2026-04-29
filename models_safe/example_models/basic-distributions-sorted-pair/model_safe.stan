parameters {
  real<lower=-1, upper=1> x1;
  real<lower=-1, upper=1> x2;
}
model {
  x1 ~ uniform(-1, 1);
  x2 ~ uniform(-1, 1);
}
generated quantities {
  real a = fmax(x1, x2);
  real b = fmin(x1, x2);
}
