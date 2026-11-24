//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N;
  array[N] int<lower=0, upper=1> A;
  array[N] real<lower=0, upper=1> Score;
  array[N] int<lower=0> M;
  array[N] int<lower=1> Y;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real b1;
  real b2;
  real b3;
}

transformed parameters{
  array[N] real q;
  for (n in 1:N)
    q[n] = inv_logit(b1 + b2*A[n] + b3*Score[n]);
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  for (n in 1:N)
    Y[n] ~ binomial(M[n], q[n]);
}

generated quantities {
  array[N] real y_pred;
  for (n in 1:N)
    y_pred[n] = binomial_rng(M[n], q[n]);
}
