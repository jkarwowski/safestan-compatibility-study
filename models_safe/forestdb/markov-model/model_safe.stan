data {
  int<lower=14, upper=14> T;
  int<lower=2> S;
  int<lower=1, upper=S> y_1;
  int<lower=1, upper=S> y_2;
  int<lower=1, upper=S> y_3;
  int<lower=1, upper=S> y_4;
  int<lower=1, upper=S> y_5;
  int<lower=1, upper=S> y_6;
  int<lower=1, upper=S> y_7;
  int<lower=1, upper=S> y_8;
  int<lower=1, upper=S> y_9;
  int<lower=1, upper=S> y_10;
  int<lower=1, upper=S> y_11;
  int<lower=1, upper=S> y_12;
  int<lower=1, upper=S> y_13;
  int<lower=1, upper=S> y_14;
}
parameters {
  simplex[S] pi;
  array[S] simplex[S] A;
}
model {
  pi ~ dirichlet(rep_vector(1.0, S));
  A ~ dirichlet(rep_vector(1.0, S));
  y_1 ~ categorical(pi);
  y_2 ~ categorical(A[y_1]);
  y_3 ~ categorical(A[y_2]);
  y_4 ~ categorical(A[y_3]);
  y_5 ~ categorical(A[y_4]);
  y_6 ~ categorical(A[y_5]);
  y_7 ~ categorical(A[y_6]);
  y_8 ~ categorical(A[y_7]);
  y_9 ~ categorical(A[y_8]);
  y_10 ~ categorical(A[y_9]);
  y_11 ~ categorical(A[y_10]);
  y_12 ~ categorical(A[y_11]);
  y_13 ~ categorical(A[y_12]);
  y_14 ~ categorical(A[y_13]);
}
