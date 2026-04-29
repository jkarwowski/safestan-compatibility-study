//# ---- irt-1pl-stan ----
data {
  int<lower=0> I;
  int<lower=0> J;
  array[I * J] int<lower=0, upper=1> y_safestan_flat;
}
parameters {
  vector[I] b;
  vector[J] theta;
}
model {
  vector[I * J] eta;

  theta ~ normal(0, 1);
  b ~ normal(-1, 2);

  for (i in 1 : I) {
    for (j in 1 : J) {
      eta[(i - 1) * J + j] = theta[j] - b[i];
    }
  }

  y_safestan_flat ~ bernoulli_logit(eta);
}
