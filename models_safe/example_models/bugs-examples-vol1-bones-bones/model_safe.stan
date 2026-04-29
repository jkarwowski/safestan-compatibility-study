data {
  int<lower=0> nChild;
  int<lower=0> nInd;
  int<lower=0> N_obs;
  array[nInd, 4] real gamma;
  array[nInd] real delta;
  array[nInd] int<lower=0> ncat;
  array[nChild] int<lower=0, upper=nInd> n_obs_child;
  array[N_obs] int<lower=1, upper=nInd> obs_ind;
  array[N_obs] int<lower=1, upper=5> grade_obs;
}
parameters {
  array[nChild] real theta;
}
model {
  array[N_obs] vector[5] p_obs;
  int pos;
  theta ~ normal(0.0, 36);
  pos = 1;
  for (i in 1 : nChild) {
    for (r in 1 : n_obs_child[i]) {
      int j;
      array[4] real Q;
      vector[5] p;
      j = obs_ind[pos];
      for (k in 1 : 5) {
        p[k] = 0;
      }
      for (k in 1 : (ncat[j] - 1)) {
        Q[k] = inv_logit(delta[j] * (theta[i] - gamma[j, k]));
      }
      p[1] = 1 - Q[1];
      for (k in 2 : (ncat[j] - 1)) {
        p[k] = Q[k - 1] - Q[k];
      }
      p[ncat[j]] = Q[ncat[j] - 1];
      p_obs[pos] = p;
      pos += 1;
    }
  }
  grade_obs ~ categorical(p_obs);
}
