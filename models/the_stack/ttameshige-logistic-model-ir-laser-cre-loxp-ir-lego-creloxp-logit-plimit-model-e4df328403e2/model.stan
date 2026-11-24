data {
  int<lower=0> N;
  vector[N] power;
  array[N] int<lower=0,upper=1> induction;
}
parameters {
  real<lower=0,upper=5> alpha;
  real<lower=-40,upper=10> beta;
  real<lower=0,upper=1> plimit;
}
transformed parameters {
  array[N] real<lower=-100,upper=100> x;
  for (k in 1:N)
    x[k]=plimit*Phi_approx(beta+alpha*power[k]);
}
model {
  for (n in 1:N)
    induction[n] ~ bernoulli(x[n]);
}
