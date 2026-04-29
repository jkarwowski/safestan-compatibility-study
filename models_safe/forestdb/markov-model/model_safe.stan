data {
  int<lower=2> T;
  int<lower=2> S;
  int<lower=1, upper=S> y_initial;
  array[T - 1] int<lower=1, upper=S> y_lag;
  array[T - 1] int<lower=1, upper=S> y_tail;
}
parameters {
  simplex[S] pi;
  array[S] simplex[S] A;
}
model {
  pi ~ dirichlet(rep_vector(1.0, S));
  A ~ dirichlet(rep_vector(1.0, S));
  y_initial ~ categorical(pi);
  y_tail ~ categorical(A[y_lag]);
}
