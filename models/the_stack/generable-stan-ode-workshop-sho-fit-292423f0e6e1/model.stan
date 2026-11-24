functions {
  array[] real sho(real t, array[] real y, array[] real theta, array[] real x_r, array[] int x_i) {
    real dy1_dt = y[2];
    real dy2_dt = -y[1] - theta[1] * y[2];
    return { dy1_dt, dy2_dt };
  }
}
data {
  int<lower = 0> T;
  real t0;
  array[T] real<lower = t0> ts;
  array[T, 2] real y_hat;
  array[2] real y0;
}
transformed data {
  array[0] real x_r;
  array[0] int x_i;
}
parameters {
  array[1] real theta;
  real<lower = 0> sigma;
}
transformed parameters {
  array[T, 2] real y = integrate_ode_bdf(sho, y0, 0.0, ts, theta, x_r, x_i);
}
model {
  sigma ~ normal(0.1, 0.1);
  theta ~ normal(0.15, 0.1);
  y0 ~ normal({1.0, 0.0}, 0.1);

  y_hat[, 1] ~ normal(y[, 1],  sigma);
  y_hat[, 2] ~ normal(y[, 2],  sigma);
}
generated quantities {
}
