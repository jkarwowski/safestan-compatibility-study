data {
  array[10] int<lower=0,upper=1> x;
}
parameters {
  real<lower=0,upper=1> theta;
}
model {
  x ~ bernoulli(theta);
  theta ~ uniform(0,1);
}
