functions {
  array[] real ode_diff(real t,array[] real V,
      array[] real theta,array[] real x_r,array[] int x_i){
    array[2] real dVdt;
    dVdt[1] = V[1] * (theta[1] * (1 - V[1] / theta[2])
      - theta[3] * V[2]);
    dVdt[2] = V[2] * (theta[4] * (1 - V[2] / theta[5])
      - theta[6] * V[1]);
    return dVdt;
  }
}

data {
  int<lower=1> T;
  array[T, 1] real V1;
  array[T, 1] real V2;
  array[T] real ts;
  array[2] real V0;
  real t0;
}

transformed data {
  array[0] real x_r;
  array[0] int x_i;
}

parameters {
  array[6] real theta;
  real sigma;
}

model {
  array[T, 1] real V_hat;
  sigma ~ cauchy(0,1); //# Prior
  theta ~ normal(0,2); //# Prior for alpha, beta
  V0 ~ normal(5,2); //# Prior for initial #
  //# Solve ODE at current parameter values
  V_hat = integrate_ode_rk45(ode_diff, V0, t0, ts,
    theta, x_r, x_i);
  //# Likelihood
  for (t in 1:T) {
    V1[t] ~ normal(V_hat[t,1],sigma);
    V2[t] ~ normal(V_hat[t,2],sigma);
  }
}
