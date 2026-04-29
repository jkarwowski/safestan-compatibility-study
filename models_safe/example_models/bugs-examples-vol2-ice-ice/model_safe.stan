data {
  int<lower=0> N;
  int<lower=0> Nage;
  int<lower=0> K;
  array[N] int year;
  array[N] int cases;
  array[N] int age;
  array[N] int pyr;
  real alpha1;
}
transformed data {
  matrix[K, K] beta_rw_chol = rep_matrix(0, K, K);

  beta_rw_chol[1, 1] = 1E3;
  beta_rw_chol[2, 2] = 1E3;
  for (k in 3 : K) {
    for (j in 1 : K) {
      beta_rw_chol[k, j] = 2 * beta_rw_chol[k - 1, j] - beta_rw_chol[k - 2, j];
    }
    beta_rw_chol[k, k] = beta_rw_chol[k, k] + 1;
  }
}
parameters {
  array[Nage - 1] real alpha;
  vector[K] beta;
  real<lower=0, upper=1> sigma;
}
model {
  vector[N] r;

  sigma ~ uniform(0, 1);
  beta ~ multi_normal_cholesky(rep_vector(0, K), sigma * beta_rw_chol);
  alpha ~ normal(0, 1000);

  for (i in 1 : N) {
    if (age[i] == 1) {
      r[i] = alpha1 + log(pyr[i]) + beta[year[i]];
    } else {
      r[i] = alpha[age[i] - 1] + log(pyr[i]) + beta[year[i]];
    }
  }

  cases ~ poisson_log(r);
}
generated quantities {
  array[K] real logRR;
  for (k in 1 : K) {
    logRR[k] = beta[k] - beta[5];
  }
}
