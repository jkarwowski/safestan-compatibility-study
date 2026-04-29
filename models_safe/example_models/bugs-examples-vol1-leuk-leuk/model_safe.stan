/*
 * Leuk: Cox regression 
 * URL of OpenBugs' implementation: 
 *   http://www.openbugs.net/Examples/Leuk.html
 */

data {
  int<lower=0> N;
  int<lower=0> NT;
  array[N] int<lower=0> obs_t;
  array[NT + 1] int<lower=0> t;
  array[N] int<lower=0> fail;
  array[N] real Z;
  int<lower=0> N_risk;
  array[N_risk] int<lower=1> risk_i;
  array[N_risk] int<lower=1> risk_j;
  array[N_risk] int<lower=0> dN_safestan;
}
transformed data {
  real c;
  real r;
  vector[NT] dL0_shape;
  c = 0.001;
  r = 0.1;
  for (j in 1 : NT) {
    dL0_shape[j] = r * (t[j + 1] - t[j]) * c;
  }
}
parameters {
  real beta;
  vector<lower=0>[NT] dL0;
}
model {
  vector[N_risk] lambda;
  beta ~ normal(0, 1000);
  dL0 ~ gamma(dL0_shape, c);
  for (m in 1 : N_risk) {
    lambda[m] = exp(beta * Z[risk_i[m]]) * dL0[risk_j[m]];
  }
  dN_safestan ~ poisson(lambda);
}
generated quantities {
  array[NT] real S_placebo;
  array[NT] real S_treat;
  
  for (j in 1 : NT) {
    // Survivor function = exp(-Integral{l0(u)du})^exp(beta*z)
    real s;
    s = 0;
    for (i in 1 : j) {
      s = s + dL0[i];
    }
    S_treat[j] = pow(exp(-s), exp(beta * -0.5));
    S_placebo[j] = pow(exp(-s), exp(beta * 0.5));
  }
}
