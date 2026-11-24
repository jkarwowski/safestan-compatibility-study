functions {
  array[] real snc(real t, array[] real y, array[] real theta, 
             array[] real x_r, array[] int x_i) {

      real C = y[1];
      array[2] real eta = theta[1:3];
      real alpha = theta[4];
      array[2] real beta = x_r[1:2];
      real ll = theta[4];
      
      real dC_dt_pos = eta[1] + eta[2] * ll + eta[2] * t;
      real dC_dt_neg = (beta[1]) / (1 + beta[2] * C) * C;
      real dC_dt = dC_dt_pos - dC_dt_neg;
      return {dC_dt};
  }
}

data {
  int<lower=1> n_obs;
  int<lower=1> n_mice;
  int<lower=1> n_weeks;
  real t0;
  array[n_obs] int tt;
  array[n_weeks] real ts;
  array[1] real y0;
  array[n_obs] real cells;
  
  array[2] real beta;
}

transformed data {
  array[2] real x_r = beta;
  array[0] int x_i;
}

parameters {
  real<lower=0> ll;
  real<lower=0> sigma;
  real<lower=0> alpha;
  array[2] real<lower=0> eta;
}

transformed parameters{
  array[n_weeks, 1] real y;
  {
    array[4] real theta;
    theta[1:2] = beta;
    
    theta[1:2] = eta;
    theta[3] = alpha;
    theta[4] = ll;
    y = integrate_ode_rk45(snc, y0, t0, ts, theta, x_r, x_i);
  }
}

model {
  // Priors drawn from the corresponding longitudinal model
  eta[1] ~ normal(.1716, .1361);
  eta[2] ~ normal(.5760, .4094);
  alpha ~ normal(.0185, .0121);
  ll ~ normal(.1267, .1002);

  sigma ~ lognormal(-1, 1);
  for (i in 1:n_obs) {
    cells[i] ~ lognormal(log(y[tt[i], 1]), sigma);
  }
}

generated quantities {
  array[n_weeks] real pred_cells;
  real log_likelihood = 0;
  pred_cells = lognormal_rng(log(y[, 1]), sigma);
  
  for (j in 1:n_obs) {
    log_likelihood += lognormal_lpdf(cells[j] | log(y[tt[j], 1]), sigma);
  }
}
