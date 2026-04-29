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
parameters {
  array[Nage - 1] real alpha;
  vector[K] beta;
  real<lower=0, upper=1> sigma;
}
model {
  vector[N] r;
  matrix[K, K] L_beta;

  sigma ~ uniform(0, 1);

  L_beta = rep_matrix(0, K, K);
  L_beta[1, 1] = sigma * 1E3;
  L_beta[2, 2] = sigma * 1E3;
  for (k in 3 : K) {
    for (j in 1 : (k - 1)) {
      L_beta[k, j] = 2 * L_beta[k - 1, j] - L_beta[k - 2, j];
    }
    L_beta[k, k] = sigma;
  }
  beta ~ multi_normal_cholesky(rep_vector(0, K), L_beta);

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
