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
  array[N, 2] real<lower=0> y; // measured populations
  vector<lower=0>[N * 2] y_safestan_flat;
}
transformed data {
  array[4] real theta_mean = {1.0, 0.05, 1.0, 0.05};
  array[4] real theta_sd = {0.5, 0.05, 0.5, 0.05};
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
  array[N, 2] real log_z;
  array[N, 2] real sigma_y;
  vector[N * 2] log_z_safestan_flat;
  vector[N * 2] sigma_y_safestan_flat;
  
  theta ~ normal(theta_mean, theta_sd);
  sigma ~ lognormal(-1, 1);
  z_init ~ lognormal(log(10), 1);
  for (k in 1 : 2) {
    log_z_init[k] = log(z_init[k]);
    for (n in 1 : N) {
      log_z[n, k] = log(z[n, k]);
      sigma_y[n, k] = sigma[k];
      log_z_safestan_flat[(n - 1) * 2 + k] = log_z[n, k];
      sigma_y_safestan_flat[(n - 1) * 2 + k] = sigma_y[n, k];
    }
  }
  y_init ~ lognormal(log_z_init, sigma);
  y_safestan_flat ~ lognormal(log_z_safestan_flat, sigma_y_safestan_flat);
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
