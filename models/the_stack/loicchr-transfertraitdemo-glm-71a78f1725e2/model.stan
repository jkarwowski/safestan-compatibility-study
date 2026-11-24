data {
  int N;
  int E;
  int SP;
  array[N, SP] int Y;
  matrix[N, E] X;
}

parameters {
  matrix[E, SP] W;
}

model {
  matrix[N, SP] pred;
  pred = X * W;
  to_vector( W ) ~ normal(0.0,3.0);
  for (n in 1:N) {
    Y[n,] ~ multinomial( softmax(to_vector(pred[n])) );
  }
}