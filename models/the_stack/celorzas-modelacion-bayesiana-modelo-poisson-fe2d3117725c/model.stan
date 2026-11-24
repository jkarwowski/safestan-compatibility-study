data {
  int N;
  array[N] int y;
}

parameters {
  real<lower=0> lambda; 
}

model {
  lambda ~ gamma(100, 2);
  y ~ poisson(lambda);
}
