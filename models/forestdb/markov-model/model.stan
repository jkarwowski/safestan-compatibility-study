data {
  int<lower=2> T;
  int<lower=2> S;
  array[T] int<lower=1, upper=S> y;
}
parameters {
  simplex[S] pi;
  array[S] simplex[S] A;
}
model {
  pi ~ dirichlet(rep_vector(1.0, S));
  for (s in 1 : S) {
    A[s] ~ dirichlet(rep_vector(1.0, S));
  }
  target += categorical_lpmf(y[1] | pi);
  for (t in 2 : T) {
    target += categorical_lpmf(y[t] | A[y[t - 1]]);
  }
}
