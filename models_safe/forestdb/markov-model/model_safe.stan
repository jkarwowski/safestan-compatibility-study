data {
  int<lower=2> T;
  int<lower=2> S;
  int<lower=1, upper=S> y_initial;
  array[S] int<lower=0> trans_counts_1;
  array[S] int<lower=0> trans_counts_2;
  array[S] int<lower=0> trans_counts_3;
}
parameters {
  simplex[S] pi;
  array[S] simplex[S] A;
}
model {
  pi ~ dirichlet(rep_vector(1.0, S));
  A ~ dirichlet(rep_vector(1.0, S));
  y_initial ~ categorical(pi);
  trans_counts_1 ~ multinomial(A[1]);
  trans_counts_2 ~ multinomial(A[2]);
  trans_counts_3 ~ multinomial(A[3]);
}
