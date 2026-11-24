// Multinomial-Dirichlet Model
//
// Parameters:
//   n: sample size
//   k: number of categories
//   y: observed sample of length n
//   a: prior parameters of length k
//
// Generates:
//   y_rep: posterior predictive datasets of size n

data {
  int<lower=0> n;
  int<lower=2> k;
  array[n] int<lower=1, upper=k> y;
  vector<lower=0>[k] a;
}

transformed data {
  // y to vector of counts
  array[k] int<lower=0> y_;
  for (i in 1:k)
    y_[i] = 0;

  for (i in 1:n)
    y_[y[i]] = y_[y[i]] + 1;
}

parameters {
  simplex[k] theta;
}

model {
  theta ~ dirichlet(a);
  y_ ~ multinomial(theta);
}

generated quantities {
  array[k] int<lower=0> y_rep;
  y_rep = multinomial_rng(theta, n);
}
