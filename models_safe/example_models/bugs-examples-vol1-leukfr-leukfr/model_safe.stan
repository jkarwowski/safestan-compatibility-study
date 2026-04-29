data {
  int<lower=0> N;
  int<lower=0> NT;
  array[N] int<lower=0> obs_t;
  array[NT + 1] int<lower=0> t;
  array[N] int<lower=0> fail;
  int<lower=0> Npair;
  array[N] int<lower=0> pair;
  array[N] real Z;
  int<lower=0> N_active;
  array[N_active] int<lower=0> dN_active;
}
transformed data {
  array[N, NT] int Y;
  real c;
  real r;
  array[NT] real dL0_alpha;
  array[N_active] int active_i;
  array[N_active] int active_j;
  int pos;

  c = 0.001;
  r = 0.1;
  pos = 1;
  for (i in 1 : N) {
    for (j in 1 : NT) {
      Y[i, j] = int_step(obs_t[i] - t[j] + .000000001);
      if (Y[i, j] != 0) {
        active_i[pos] = i;
        active_j[pos] = j;
        pos = pos + 1;
      }
    }
  }
  for (j in 1 : NT) {
    dL0_alpha[j] = r * (t[j + 1] - t[j]) * c;
  }
}
parameters {
  real beta;
  real<lower=0> tau;
  array[NT] real<lower=0> dL0;
  array[Npair] real b;
}
transformed parameters {
  real<lower=0> sigma;
  sigma = 1 / sqrt(tau);
}
model {
  array[N_active] real lambda_active;

  beta ~ normal(0, 1000);
  tau ~ gamma(.001, .001);
  b ~ normal(0, sigma);
  dL0 ~ gamma(dL0_alpha, c);

  for (k in 1 : N_active) {
    lambda_active[k] = exp(beta * Z[active_i[k]] + b[pair[active_i[k]]])
                       * dL0[active_j[k]];
  }
  dN_active ~ poisson(lambda_active);
}
