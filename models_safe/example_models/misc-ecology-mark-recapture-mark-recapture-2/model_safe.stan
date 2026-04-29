data {
  int<lower=0> M; // marked
  int<lower=0> C; // captured
  int<lower=0, upper=min(M, C)> R; // recaptured
  int<lower=0, upper=min(M, C)> R_safestan_copy; // deterministic copy of R
}
transformed data {
  real theta_max;
  theta_max = M;
  theta_max = theta_max / (C - R_safestan_copy + M);
}
parameters {
  real<lower=0, upper=theta_max> theta; // proportion marked
}
model {
  theta ~ uniform(0, theta_max);
  R ~ binomial(C, theta);
}
generated quantities {
  real<lower=(C - R_safestan_copy + M)> N; // population
  N = M / theta;
}
