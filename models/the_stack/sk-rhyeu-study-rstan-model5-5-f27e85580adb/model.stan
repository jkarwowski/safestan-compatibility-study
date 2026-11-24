data {
  int I;
  array[I] int<lower=0, upper=1> A;
  array[I] real<lower=0, upper=1> Score;
  array[I] real<lower=0, upper=1> W;
  array[I] int<lower=0, upper=1> Y;
}

parameters {
  array[4] real b;
}

transformed parameters {
  array[I] real q;
  for (i in 1:I)
    q[i] = inv_logit(b[1] + b[2] * A[i] + b[3] * Score[i] + b[4] * W[i]);
}

model {
  for (i in 1:I)
    Y[i] ~ bernoulli(q[i]);
}
