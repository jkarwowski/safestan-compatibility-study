functions {
  real length_adjust(real theta, array[] real L) {
    real p1 = theta * L[1];
    real p2 = (1 - theta) * L[2];
    return p1 / (p1 + p2);
  }
}
data {
  int<lower=0> N;
  int<lower=0, upper=N> y;
  array[2] real<lower=0> L;
}
parameters {
  real<lower=0, upper=1> psi;
}
transformed parameters {
  real<lower=0, upper=1> theta = length_adjust(psi, L);
}
model {
  psi ~ beta(1, 1);
  y ~ binomial(N, theta);
}
