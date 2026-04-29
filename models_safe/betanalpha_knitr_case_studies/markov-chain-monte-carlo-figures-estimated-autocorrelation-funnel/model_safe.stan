parameters {
  real x;
  real log_tau;
}

model {
  log_tau ~ normal(0, 1);
  x ~ normal(0, exp(log_tau));
}
