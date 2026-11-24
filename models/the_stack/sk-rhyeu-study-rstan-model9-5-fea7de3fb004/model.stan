data {
  int K;
  array[K] int<lower=0> Y;
}

parameters {
  simplex[K] theta;
}

model {
  Y ~ multinomial(theta);
}
