// Figure 2
data {
  int N;
  array[N] int<lower=0,upper=1> x;
}
parameters {
  real<lower=0,upper=1> z;
}
model {
  z ~ beta(1, 1);
  x ~ bernoulli(z);
}