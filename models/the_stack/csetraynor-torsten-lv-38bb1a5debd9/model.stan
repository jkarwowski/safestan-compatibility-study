functions {
  array[] real dz_dt(real t,       // time
               array[] real z,     // system state {prey, predator}
               array[] real theta, // parameters
               array[] real x_r,   // unused data
               array[] int x_i) {
    real u = z[1];
    real v = z[2];

    real alpha = theta[1];
    real beta = theta[2];
    real gamma = theta[3];
    real delta = theta[4];

    real du_dt = (alpha - beta * v) * u;
    real dv_dt = (-gamma + delta * u) * v;
    return { du_dt, dv_dt };
  }
}
data {
  int<lower = 0> N_subj;      // number of subjects
  int<lower = 0> N;           // number of measurement times
  array[N] real ts_0;                 // measurement times > 0
  array[2] real y0_0;     // initial measured populations
  array[N, 2] real<lower = 0> y_0;    // measured populations
}
transformed data {
  array[N_subj] int len = rep_array(N, N_subj);
  array[N_subj, 2] real y0 = rep_array(y0_0, N_subj);
  array[N_subj, N, 2] real y = rep_array(y_0, N_subj);
  array[N_subj * N] real ts;
  for (i in 1:N_subj) {
    ts[((i-1)*N + 1) : (i*N)] = ts_0;
  }
}

parameters {
  array[N_subj, 4] real<lower = 0> theta;   // { alpha, beta, gamma, delta }
  array[N_subj, 2] real<lower = 0> z_init;  // initial population
  array[N_subj, 2] real<lower = 0> sigma;   // measurement errors
}
transformed parameters {
  array[N_subj, N, 2] real z;
  for (isub in 1:N_subj) {
    z[isub] = integrate_ode_rk45(dz_dt, z_init[isub], 0, ts[((isub-1)*N+1):(isub*N)], theta[isub], rep_array(0.0, 0), rep_array(0, 0));
  }
}
model {
  for (isub in 1:N_subj) {
    theta[isub, {1, 3}] ~ normal(1, 0.5);
    theta[isub, {2, 4}] ~ normal(0.05, 0.05);
    sigma[isub] ~ lognormal(-1, 1);
    z_init[isub] ~ lognormal(10, 1);
    for (k in 1:2) {
      y0[isub, k] ~ lognormal(log(z_init[isub, k]), sigma[isub, k]);
      y[isub, , k] ~ lognormal(log(z[isub, , k]), sigma[isub, k]);
    }
  }
}
