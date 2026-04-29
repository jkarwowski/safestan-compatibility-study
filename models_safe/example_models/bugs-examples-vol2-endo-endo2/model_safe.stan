/*
 * Endo: conditional inference in case-contrl studies 
 * http://www.openbugs.net/Examples/Endo.html
 *
 * In this example, three methods of different 
 * model specifications are used for one equivalent
 * model. This is method 2. 
 *
 * SafeStan rewrite: the original manual target increments are represented
 * as one vectorized Bernoulli-logit likelihood for the deterministic
 * transformed-data outcome Y[, 1], supplied as top-level protected data.
 */
data {
  int n10;
  int n01;
  int n11;
  int I;
  int J;
  array[I] int<lower=0, upper=1> y_safestan;
}
transformed data {
  array[I, 2] int<lower=0> est;
  vector[I] x;

  for (i in 1 : n10) {
    est[i, 1] = 1;
    est[i, 2] = 0;
  }
  for (i in (n10 + 1) : (n10 + n01)) {
    est[i, 1] = 0;
    est[i, 2] = 1;
  }
  for (i in (n10 + n01 + 1) : (n10 + n01 + n11)) {
    est[i, 1] = 1;
    est[i, 2] = 1;
  }
  for (i in (n10 + n01 + n11 + 1) : I) {
    est[i, 1] = 0;
    est[i, 2] = 0;
  }
  for (i in 1 : I) {
    x[i] = est[i, 1] - est[i, 2];
  }
}
parameters {
  real beta;
}
model {
  vector[I] eta;

  beta ~ normal(0, 1000);

  for (i in 1 : I) {
    eta[i] = beta * x[i];
  }
  y_safestan ~ bernoulli_logit(eta);
}
