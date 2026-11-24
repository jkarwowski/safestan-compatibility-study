data {
  int<lower=2> K;
  int<lower=1> I;
  int<lower=1> J;
  array[I, J] int<lower=1,upper=K> y;
  vector<lower=0>[K] alpha;
  array[K] vector<lower=0>[K] beta;
}
parameters {
  simplex[K] pi;
  array[J, K] simplex[K] theta;
}
transformed parameters {
  array[I] vector[K] log_q_z;
  for (i in 1:I) {
    log_q_z[i] = log(pi);
    for (j in 1:J)
      for (k in 1:K)
        log_q_z[i, k] = log_q_z[i, k]
          + log(theta[j, k, y[i, j]]);
} }
model {
  pi ~ dirichlet(alpha);
  for (j in 1:J)
    for (k in 1:K)
        theta[j, k] ~ dirichlet(beta[k]);
    for (i in 1:I)
      target += log_sum_exp(log_q_z[i]);
}