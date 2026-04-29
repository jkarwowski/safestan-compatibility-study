data {
  int<lower=0> G;
  int<lower=0> N;
  array[G * N] int<lower=0> r;
  array[G * N] int<lower=0> n;
}
parameters {
  vector<lower=0, upper=1>[G * N] p_safestan_flat;
  vector<lower=0.1>[G] a;
  vector<lower=0.1>[G] b;
}
transformed parameters {
  matrix<lower=0, upper=1>[G, N] p;
  for (g in 1 : G) {
    for (i in 1 : N) {
      p[g, i] = p_safestan_flat[(g - 1) * N + i];
    }
  }
}
model {
  vector[G * N] a_safestan_flat;
  vector[G * N] b_safestan_flat;
  a ~ gamma(1, 0.001);
  b ~ gamma(1, 0.001);
  for (g in 1 : G) {
    for (i in 1 : N) {
      a_safestan_flat[(g - 1) * N + i] = a[g];
      b_safestan_flat[(g - 1) * N + i] = b[g];
    }
  }
  p_safestan_flat ~ beta(a_safestan_flat, b_safestan_flat);
  r ~ binomial(n, p_safestan_flat);
}
generated quantities {
  vector<lower=0, upper=1>[G] mu;
  vector<lower=0>[G] theta;
  for (g in 1 : G) {
    mu[g] = a[g] / (a[g] + b[g]);
  }
  for (g in 1 : G) {
    theta[g] = 1 / (a[g] + b[g]);
  }
}
