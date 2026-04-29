//# ---- irt-1pl-stan ----
data {
  int<lower=0> I;
  int<lower=0> J;
  array[I * J] int<lower=0, upper=1> y;
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
  y ~ bernoulli_logit(eta);
}
generated quantities {
  array[100] int<lower=0, upper=I> z_sim;
  array[40] real theta_sim;
  for (j in 1 : 40) {
    theta_sim[j] = (j - 20) / 4.0;
    z_sim[j] = 0;
    for (i in 1 : I) {
      if (bernoulli_logit_rng(theta_sim[j] - b[i])) {
        z_sim[j] = z_sim[j] + 1;
      }
    }
  }
}
