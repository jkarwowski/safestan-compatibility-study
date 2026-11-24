data {
  int N;
  vector<lower=0, upper=1>[N] A;
  vector<lower=0, upper=1>[N] Score;
  array[N] int<lower=0> M;
}

parameters {
  array[3] real b;
}

transformed parameters {
  vector[N] lambda;
  lambda = b[1] + b[2] * A + b[3] * Score;
}

model {
  M ~ poisson_log(lambda);
}

generated quantities {
  array[N] int m_pred;
  for (n in 1:N)
    m_pred[n] = poisson_log_rng(lambda[n]);
}
