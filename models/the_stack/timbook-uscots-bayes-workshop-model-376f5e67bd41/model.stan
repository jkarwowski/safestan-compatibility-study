data {
  int J;
  array[J] int filters;
}

parameters {
  real lambda;
}

model {
  lambda ~ exponential(1/6.0);
  filters ~ poisson(lambda);
}