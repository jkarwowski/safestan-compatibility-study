// the original version not using transformation is in ring.stan.0
parameters {
  real<lower=0.5, upper=1> z;
  real<lower=0, upper=2 * pi()> phi;
}
model {
  z ~ beta(2, 1) T[0.5, 1];
  phi ~ uniform(0, 2 * pi());
}
generated quantities {
  real x;
  real y;
  x = z * cos(phi);
  y = z * sin(phi);
}
