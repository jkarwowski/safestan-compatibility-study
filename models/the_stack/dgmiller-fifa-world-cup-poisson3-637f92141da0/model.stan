data {
  int<lower=1> N; // number of matches
  int<lower=1> T; // number of teams
  array[N] int<lower=1, upper=T> I; // home team for match n
  array[N] int<lower=1, upper=T> J; // away team for match n
  array[2, T] real<lower=0> X1; // attempts mean and variance
  array[2, T] real<lower=0> X2; // on/off target pseudocounts
  array[2, T] real<lower=0> X3; // save/goal pseudocounts
  array[T, T] int<lower=0> Y; // goals from matches
}

parameters {
  array[T] real<lower=0> attempts; // attempts at goal
  array[T] real<lower=0, upper=1> sot_rate; // shot on target rate
  array[T] real<lower=0, upper=1> fts_rate; // fail to save rate
}

model {
  attempts ~ chi_square(X1[1]);
  sot_rate ~ beta(X2[1], X2[2]);
  fts_rate ~ beta(X3[1], X3[2]);
  for (n in 1:N) {
    Y[I[n], J[n]] ~ poisson(attempts[I[n]]*sot_rate[I[n]]*fts_rate[J[n]]);
    Y[J[n], I[n]] ~ poisson(attempts[J[n]]*sot_rate[J[n]]*fts_rate[I[n]]);
  }
}

generated quantities {
  matrix[T, T] EG; // expected goals prediction
  for (i in 1:T) {
    for (j in 1:T) {
      EG[i,j] = poisson_rng(attempts[i]*sot_rate[i]*fts_rate[j]);
      EG[j,i] = poisson_rng(attempts[j]*sot_rate[j]*fts_rate[i]);
    }
  }
}

