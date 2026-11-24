functions {
  real pcm(int obs_gpcm, real theta, vector beta) {
    vector[rows(beta) + 1] unsummed;
    vector[rows(beta) + 1] probs;
    unsummed = append_row(rep_vector(0.0, 1), theta - beta);
    probs = softmax(cumulative_sum(unsummed));
    return categorical_lpmf(obs_gpcm + 1 | probs);
  }
}
data {
  int<lower=1> I;                // # items
  int<lower=1> J;                // # persons
  int<lower=1> N;                // # responses
  array[N] int<lower=1,upper=I> ii;    // i for n
  array[N] int<lower=1,upper=J> jj;    // j for n
  array[N] int<lower=0> obs_gpcm;             // response for n; y = 0, 1 ... m_i
}
transformed data {
  array[I] int m;                      // # parameters per item
  array[I] int pos;                    // first position in beta vector for item
  m = rep_array(0, I);
  for(n in 1:N)
    if(obs_gpcm[n] > m[ii[n]]) m[ii[n]] = obs_gpcm[n];
  pos[1] = 1;
  for(i in 2:(I))
    pos[i] = m[i-1] + pos[i-1];
}
parameters {
  vector[sum(m)-1] beta_free;
  vector[J] theta;
}
transformed parameters {
  vector[sum(m)] beta;
  beta[1:(sum(m)-1)] = beta_free;
  beta[sum(m)] = -1*sum(beta_free);
}
model {
  target += normal_lpdf(beta | 0, 2);
  theta ~ normal(0, 1);
  for (n in 1:N)
    target += pcm(obs_gpcm[n], theta[jj[n]],  segment(beta, pos[ii[n]], m[ii[n]]));
}