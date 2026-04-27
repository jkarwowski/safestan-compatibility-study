data {
  int<lower=14, upper=14> T;
  int<lower=3, upper=3> S;
  int<lower=1, upper=S> y_initial;
  int<lower=0, upper=T - 1> N_from_1;
  array[N_from_1] int<lower=1, upper=S> y_after_1;
  int<lower=0, upper=T - 1> N_from_2;
  array[N_from_2] int<lower=1, upper=S> y_after_2;
  int<lower=0, upper=T - 1> N_from_3;
  array[N_from_3] int<lower=1, upper=S> y_after_3;
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
  y_initial ~ categorical(pi);
  y_after_1 ~ categorical(A[1]);
  y_after_2 ~ categorical(A[2]);
  y_after_3 ~ categorical(A[3]);
}
