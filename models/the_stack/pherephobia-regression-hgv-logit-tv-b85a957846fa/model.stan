data {
  int N;
  vector [N] x;
  array[N] int y;
}
parameters {
  real a;
  real b;
}
model {
  y ~ bernoulli_logit(a + b * x);
}
