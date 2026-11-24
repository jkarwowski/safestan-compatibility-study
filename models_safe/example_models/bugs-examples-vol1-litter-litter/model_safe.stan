data {
  int<lower=0> G;
  int<lower=0> N;
  array[G, N] int<lower=0> r;
  array[G, N] int<lower=0> n;
  array[G * N] int<lower=0> r_safestan_flat;
}
parameters {
  vector<lower=0, upper=1>[G * N] p_raw;
  vector<lower=0, upper=1>[G] mu;
  vector<lower=0.1>[G] a_plus_b;
}
transformed parameters {
  vector[G] a;
  vector[G] b;
  array[G, N] real<lower=0, upper=1> p;
  array[G, N] real<lower=0> a_rep;
  array[G, N] real<lower=0> b_rep;
  vector[G * N] a_flat;
  vector[G * N] b_flat;
  a = mu .* a_plus_b;
  b = (1 - mu) .* a_plus_b;
  for (g in 1 : G) {
    for (i in 1 : N) {
      p[g, i] = p_raw[(g - 1) * N + i];
      a_rep[g, i] = a[g];
      b_rep[g, i] = b[g];
      a_flat[(g - 1) * N + i] = a[g];
      b_flat[(g - 1) * N + i] = b[g];
    }
  }
}
model {
  array[G * N] int n_flat;
  mu ~ uniform(0, 1);
  a_plus_b ~ pareto(0.1, 1.5);
  for (g in 1 : G) {
    for (i in 1 : N) {
      n_flat[(g - 1) * N + i] = n[g, i];
    }
  }
  p_raw ~ beta(a_flat, b_flat);
  r_safestan_flat ~ binomial(n_flat, p_raw);
}
generated quantities {
  vector<lower=0>[G] theta;
  for (g in 1 : G) {
    theta[g] = 1 / (a[g] + b[g]);
  }
}
