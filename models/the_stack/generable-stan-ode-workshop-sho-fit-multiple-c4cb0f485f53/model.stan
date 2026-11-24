functions {
  array[] real sho(real t, array[] real y, array[] real theta, array[] real x_r, array[] int x_i) {
    real dy1_dt = y[2];
    real dy2_dt = -y[1] - theta[1] * y[2];
    return { dy1_dt, dy2_dt };
  }
}
data {
  int<lower = 0> T;
  int<lower = 0> N;
  real t0;
  array[T] real<lower = t0> ts;
  array[N, T, 2] real y_hat;
  array[N, 2] real y0;
}
transformed data {
  array[0] real x_r;
  array[0] int x_i;
}
parameters {
  array[N, 1] real theta;
  real<lower = 0> sigma;
}
transformed parameters {
  array[N, T, 2] real y;
  for (n in 1:N) {
    y[n, , ] = integrate_ode_bdf(sho, y0[n], 0.0, ts, theta[n], x_r, x_i);
  }
}
model {
  sigma ~ normal(0.1, 0.1);
  for (n in 1:N) {
    theta[n, 1] ~ normal(0.15, 0.1);
    y0[n] ~ normal({1.0, 0.0}, 0.1);
  }

  for (n in 1:N) {
    y_hat[n, , 1] ~ normal(y[n, , 1],  sigma);
    y_hat[n, , 2] ~ normal(y[n, , 2],  sigma);
  }
}
generated quantities {
}
