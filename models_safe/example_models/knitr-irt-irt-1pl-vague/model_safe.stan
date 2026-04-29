//# ---- irt-1pl-vague-stan ----
data {
  int<lower=0> I;
  int<lower=0> J;
  array[I, J] int<lower=0, upper=1> y;
  array[I * J] int<lower=0, upper=1> y_safestan_flat;
  real mu_theta;
  real<lower=0> sigma_theta;
  real mu_b;
  real<lower=0> sigma_b;
}
parameters {
  vector[I] b;
  vector[J] theta;
}
model {
  vector[I * J] eta_safestan_flat;

  theta ~ normal(mu_theta, sigma_theta);
  b ~ normal(mu_b, sigma_b);

  for (i in 1 : I) {
    for (j in 1 : J) {
      eta_safestan_flat[(i - 1) * J + j] = theta[j] - b[i];
    }
  }
  y_safestan_flat ~ bernoulli_logit(eta_safestan_flat);
}
