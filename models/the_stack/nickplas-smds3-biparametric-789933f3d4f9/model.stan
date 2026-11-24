data{
  int N;
  array[N] real y;
  real a;
  real b;
}
parameters{
  real theta;
  real<lower=0> sigma;
}
model{
  target+=normal_lpdf(y|theta, sigma);
  target+=uniform_lpdf(theta|a, b );
  target+=uniform_lpdf(sigma|0.1,10);
}
