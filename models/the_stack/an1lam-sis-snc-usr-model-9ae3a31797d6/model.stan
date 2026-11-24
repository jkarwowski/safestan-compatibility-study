functions {
  array[] real snc(real t, array[] real y, array[] real theta, 
             array[] real x_r, array[] int x_i) {

      real C = y[1];
      array[2] real eta = theta[1:2];
      array[2] real beta = theta[3:4];

      
      real dC_dt_pos = (eta[1] + eta[2] * t);
      real dC_dt_neg = (beta[1] - beta[2] * t) * C;
      real dC_dt = dC_dt_pos - dC_dt_neg;
      return {dC_dt};
  }
}

data {
  int<lower=1> n_weeks;
  int<lower=1> n_mice;
  real t0;
  array[n_weeks] real ts;
  array[n_mice, n_weeks] real cells;
}

transformed data {
  array[0] real x_r;
  array[0] int x_i;
}
parameters {
  array[2] real<lower=0> eta;
  array[2] real<lower=0> beta;
  real<lower=0> sigma;
  array[1] real<lower=0> y_init;
}
transformed parameters{
  array[n_weeks, 1] real y;
  {
    array[4] real theta;
    theta[1:2] = eta;
    theta[3:4] = beta;
    y = integrate_ode_rk45(snc, y_init, t0, ts, theta, x_r, x_i);
  }
}

model {
  // Priors
  eta[1] ~ normal(0, 0.78);
  eta[2] ~ normal(0, 1);
  beta[1] ~ normal(0, 0.78);
  beta[2] ~ normal(0, 1);
  sigma ~ lognormal(-1, 1);
  
  // Sample cell counts for each mouse.
  y_init[1] ~ lognormal(log(1), 1);
  for (i in 1:n_mice) {
    cells[i] ~ lognormal(log(y[, 1]), sigma);
  }
}

generated quantities {
  array[n_mice, n_weeks] real pred_cells;
  array[n_weeks] real pred_cells_means;
  real log_likelihood = 0;
  
  for (i in 1:n_mice) {
    pred_cells[i] = lognormal_rng(log(y[, 1]), sigma);
    for (j in 1:n_weeks) {
      log_likelihood += lognormal_lpdf(cells[i, j] | log(y[j, 1]), sigma);
    }
  }
  
  for (i in 1:n_weeks) {
    pred_cells_means[i] = mean(pred_cells[:, i]);
  }
}
