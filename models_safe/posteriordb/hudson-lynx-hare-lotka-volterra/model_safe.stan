functions {
  array[] real dz_dt(real t, // time
                     array[] real z,
                     // system state {prey, predator}
                     array[] real theta, // parameters
                     array[] real x_r, // unused data
                     array[] int x_i) {
    real u = z[1];
    real v = z[2];
    
    real alpha = theta[1];
    real beta = theta[2];
    real gamma = theta[3];
    real delta = theta[4];
    
    real du_dt = (alpha - beta * v) * u;
    real dv_dt = (-gamma + delta * u) * v;
    return {du_dt, dv_dt};
  }
}
data {
  int<lower=0> N; // number of measurement times
  array[N] real ts; // measurement times > 0
  array[2] real y_init; // initial measured populations
  vector<lower=0>[N] y_1; // measured prey populations
  vector<lower=0>[N] y_2; // measured predator populations
}
transformed data {
  array[4] real theta_mu = {1, 0.05, 1, 0.05};
  array[4] real theta_sigma = {0.5, 0.05, 0.5, 0.05};
}
parameters {
  array[4] real<lower=0> theta; // { alpha, beta, gamma, delta }
  array[2] real<lower=0> z_init; // initial population
  array[2] real<lower=0> sigma; // measurement errors
}
transformed parameters {
  array[N, 2] real z = integrate_ode_rk45(dz_dt, z_init, 0, ts, theta,
                                          rep_array(0.0, 0), rep_array(
                                          0, 0), 1e-5, 1e-3, 5e2);
}
model {
  array[2] real log_z_init;
  vector[N] log_z_1;
  vector[N] log_z_2;

  theta ~ normal(theta_mu, theta_sigma);
  sigma ~ lognormal(-1, 1);
  z_init ~ lognormal(log(10), 1);

  for (k in 1 : 2) {
    log_z_init[k] = log(z_init[k]);
  }
  for (n in 1 : N) {
    log_z_1[n] = log(z[n, 1]);
    log_z_2[n] = log(z[n, 2]);
  }

  y_init ~ lognormal(log_z_init, sigma);
  y_1 ~ lognormal(log_z_1, sigma[1]);
  y_2 ~ lognormal(log_z_2, sigma[2]);
}
generated quantities {
  array[2] real y_init_rep;
  array[N, 2] real y_rep;
  for (k in 1 : 2) {
    y_init_rep[k] = lognormal_rng(log(z_init[k]), sigma[k]);
    for (n in 1 : N) {
      y_rep[n, k] = lognormal_rng(log(z[n, k]), sigma[k]);
    }
  }
}
