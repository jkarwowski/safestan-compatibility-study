functions {
  array[] real snc(real t, array[] real y, array[] real theta, 
             array[] real x_r, array[] int x_i) {

      real C = y[1];
      array[3] real eta = theta[1:3];
      array[3] real beta = theta[4:6];

      
      real dC_dt_pos = (eta[1] + eta[2] * t) * (1 + eta[3] * C);
      real dC_dt_neg = (beta[1] - beta[2] * t) / (1 + beta[3] * C) * C;
      real dC_dt = dC_dt_pos - dC_dt_neg;
      return {dC_dt};
  }
}

data {
  int<lower=1> n_weeks;
  int<lower=1> n_mice;
  array[1] real y0;
  real t0;
  array[n_weeks] real ts;
  array[n_mice, n_weeks] real cells;
}

transformed data {
  array[0] real x_r;
  array[0] int x_i;
}
parameters {
  array[3] real<lower=0> eta;
  array[3] real<lower=0> beta;
  real<lower=0> eps_inv;
}
transformed parameters{
  array[n_mice, n_weeks, 1] real y;
  real eps = 1. / eps_inv;
  {
    array[6] real theta;
    theta[1:3] = eta;
    theta[4:6] = beta;
    for (i in 1:n_mice) {
      y[i] = integrate_ode_rk45(snc, y0, t0, ts, theta, x_r, x_i);
    }
  }
}

model {
  // Priors
  for (i in 1:3) {
    eta[i] ~ normal(0.5, 0.5);
  }
  for (i in 1:3) {
    beta[i] ~ normal(0.5, 0.5);
  }
  eps_inv ~ gamma(2, 0);
  
  // Sample cell counts for each mice.
  for (i in 1:n_mice) {
    for (j in 1:n_weeks) {
      cells[i, j] ~ normal(y[i, j, 1], eps);
    }
  }
}
