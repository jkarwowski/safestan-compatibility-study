data {
  int<lower=1> J;              // number of students
  int<lower=1> K;              // number of questions
  int<lower=1> N;              // number of observations
  array[N] int<lower=1,upper=J> jj;  // student for observation n
  array[N] int<lower=1,upper=K> kk;  // question for observation n
  array[N] int<lower=0,upper=1> y;   // correctness for observation n
}

parameters {
  real delta;         // mean student ability
  vector[J] alpha;      // ability of student j - mean ability
  vector[K] beta;       // difficulty of question k
}

model {
  alpha ~ normal(0, 1);         // informative true prior
  beta ~ normal(0, 1);          // informative true prior
  delta ~ normal(0.75, 1);      // informative true prior
  y ~ bernoulli_logit(alpha[jj] - beta[kk] + delta);
}
