data {
  int<lower=0> G;
  int<lower=0> N;
  array[G, N] int<lower=0> r;
  array[G, N] int<lower=0> n;
}
parameters {
  array[G, N] real<lower=0, upper=1> p;
  vector<lower=0, upper=1>[G] mu;
  vector<lower=0.1>[G] a_plus_b;
}
transformed parameters {
  vector[G] a;
  vector[G] b;
  array[G, N] real<lower=0> a_rep;
  array[G, N] real<lower=0> b_rep;
  a = mu .* a_plus_b;
  b = (1 - mu) .* a_plus_b;
  for (g in 1 : G) {
    for (i in 1 : N) {
      a_rep[g, i] = a[g];
      b_rep[g, i] = b[g];
    }
  }
}
model {
  mu ~ uniform(0, 1);
  a_plus_b ~ pareto(0.1, 1.5);
  p ~ beta(a_rep, b_rep);
  r ~ binomial(n, p);
}
generated quantities {
  vector<lower=0>[G] theta;
  for (g in 1 : G) {
    theta[g] = 1 / (a[g] + b[g]);
  }
}
