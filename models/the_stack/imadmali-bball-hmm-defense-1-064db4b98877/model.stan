// defensive model 1 estimate transition matrix (assignment for all 5 defenders)
data {
  int<lower=0> N;       // number of time steps
  int<lower=0> K;       // number of offensive players
  int<lower=0> I;       // number of defenders
  real<lower=0> tau;    // scale parameter associated with convex combination
  vector[3] alpha;      // prior on convex combination parameters
  array[K] vector[K] beta;    // prior on transition matrix
  vector[2] h;          // location of hoop
  array[N] vector[2] b;       // location of ball (array of size N containing vectors of size 2)
  array[I, N] vector[2] d;     // location of defenders (array of size I,K containing vectors of size 2)
  array[K, N] vector[2] o;     // location of offensive players (array of size K,N containing vectors of size 2)
}

parameters {
  array[K] simplex[K] theta;
  simplex[3] lambda;
}

model {
  // priors
  target+= dirichlet_lpdf(lambda | alpha);
  for (k in 1:K)
    target+= dirichlet_lpdf(theta[k] | beta[k]);
  // forward algorithm
  for (i in 1:I) {
    array[K] real acc;
    array[N, K] real gamma;
    for (k in 1:K)
      gamma[1, k] = normal_lpdf(d[i,1] |  o[k,1]*lambda[1] + h*lambda[2] + b[1]*lambda[3], tau);
    for (t in 2:N) {
      for (k in 1:K) {
        for (j in 1:K)
          acc[j] = gamma[t-1, j] + log(theta[j, k])
            + normal_lpdf(d[i,t] |  o[k,t]*lambda[1] + h*lambda[2] + b[t]*lambda[3], tau);
        gamma[t, k] = log_sum_exp(acc);
      }
    }
    target += log_sum_exp(gamma[N]);
  }
}

generated quantities {
  array[I, N] int<lower=1,upper=K> z_star;
  real log_p_z_star;
  for (i in 1:I) {
    array[N, K] int back_ptr;
    array[N, K] real best_logp;
    for (k in 1:K)
      best_logp[1, k] = normal_lpdf(d[i,1] |  o[k,1]*lambda[1] + h*lambda[2] + b[1]*lambda[3], tau);
    for (t in 2:N) {
      for (k in 1:K) {
        best_logp[t, k] = negative_infinity();
        for (j in 1:K) {
          real logp;
          logp = best_logp[t-1, j] + log(theta[j, k])
            + normal_lpdf(d[i,t] |  o[k,t]*lambda[1] + h*lambda[2] + b[t]*lambda[3], tau);
          if (logp > best_logp[t, k]) {
            back_ptr[t, k] = j;
            best_logp[t, k] = logp;
          }
        }
      }
    }
    log_p_z_star = max(best_logp[N]);
    for (k in 1:K)
      if (best_logp[N, k] == log_p_z_star)
        z_star[i,N] = k;
    for (t in 1:(N - 1))
      z_star[i, N - t] = back_ptr[N - t + 1, z_star[i, N - t + 1]];
  }
}
