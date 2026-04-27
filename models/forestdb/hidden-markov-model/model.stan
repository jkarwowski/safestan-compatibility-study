data {
  int<lower=2> T;
  int<lower=2> S;
  int<lower=2> K;
  array[T] int<lower=1, upper=K> y;
}
parameters {
  simplex[S] pi;
  array[S] simplex[S] A;
  array[S] simplex[K] omega;
}
model {
  matrix[T, S] log_alpha;
  pi ~ dirichlet(rep_vector(1.0, S));
  for (s in 1 : S) {
    A[s] ~ dirichlet(rep_vector(1.0, S));
    omega[s] ~ dirichlet(rep_vector(1.0, K));
  }
  for (s in 1 : S) {
    log_alpha[1, s] = log(pi[s]) + categorical_lpmf(y[1] | omega[s]);
  }
  for (t in 2 : T) {
    for (s in 1 : S) {
      vector[S] acc;
      for (prev in 1 : S) {
        acc[prev] = log_alpha[t - 1, prev] + log(A[prev][s]);
      }
      log_alpha[t, s] = categorical_lpmf(y[t] | omega[s]) + log_sum_exp(acc);
    }
  }
  {
    vector[S] last;
    for (s in 1 : S) {
      last[s] = log_alpha[T, s];
    }
    target += log_sum_exp(last);
  }
}
