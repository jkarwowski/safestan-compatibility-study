functions {
  array[] real snc(real t, array[] real y, array[] real theta, 
             array[] real x_r, array[] int x_i) {

      real C = y[1];
      real eta = theta[1];
      array[2] real beta = theta[2:3];

      
      real dC_dt_pos = eta;
      real dC_dt_neg = (beta[1] - beta[2] * t) * C;
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
  real<lower=0> eta;
  array[2] real<lower=0> beta;
  array[n_weeks] real<lower=.001> eps_inv;
}
transformed parameters{
  array[n_mice, n_weeks, 1] real y;
  array[n_weeks] real eps;
  {
    array[3] real theta;
    theta[1] = eta;
    theta[2:3] = beta;
    for (j in 1:n_weeks) {
      eps[j] = 1. / eps_inv[j];
    }
    
    for (i in 1:n_mice) {
      y[i] = integrate_ode_bdf(snc, y0, t0, ts, theta, x_r, x_i);
    }
  }
}

model {
  // Priors
  // eta ~ gamma(2, 0.1);
  // for (i in 1:2) {
  //   beta[i] ~ gamma(2., 0.5);
  // }
  eps_inv ~ gamma(2, 0.1);
  // 
  // Sample cell counts for each mouse.
  print("eta: ", eta, "beta: ", beta, "eps: ", eps);
  for (i in 1:n_mice) {
    for (j in 1:n_weeks) {
      cells[i, j] ~ normal(y[i, j, 1], eps[j]);
    }
  }
}

generated quantities {
  array[n_mice, n_weeks] real pred_cells;
  array[n_weeks] real pred_cells_means;
  for (i in 1:n_mice) {
    for (j in 1:n_weeks) {
      pred_cells[i, j] = normal_rng(y[i, j, 1], eps[j]);
    }
  }
  for (i in 1:n_weeks) {
    pred_cells_means[i] = mean(pred_cells[:, i]);
  }
}
