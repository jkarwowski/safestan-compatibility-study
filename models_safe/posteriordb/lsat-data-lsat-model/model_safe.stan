data {
  int<lower=0> N; // number of students
  int<lower=0> T; // number of questions
  array[N] int<lower=0, upper=1> r_1;
  array[N] int<lower=0, upper=1> r_2;
  array[N] int<lower=0, upper=1> r_3;
  array[N] int<lower=0, upper=1> r_4;
  array[N] int<lower=0, upper=1> r_5;
}
transformed data {
  vector[N] ones = rep_vector(1.0, N);
}
parameters {
  array[T] real alpha;
  vector[N] theta;
  real<lower=0> beta;
}
model {
  alpha ~ normal(0, 100.);
  theta ~ normal(0, 1);
  beta ~ normal(0.0, 100.);

  r_1 ~ bernoulli_logit(beta * theta - alpha[1] * ones);
  r_2 ~ bernoulli_logit(beta * theta - alpha[2] * ones);
  r_3 ~ bernoulli_logit(beta * theta - alpha[3] * ones);
  r_4 ~ bernoulli_logit(beta * theta - alpha[4] * ones);
  r_5 ~ bernoulli_logit(beta * theta - alpha[5] * ones);
}
generated quantities {
  real mean_alpha;
  array[T] real a;
  mean_alpha = mean(alpha);
  for (t in 1 : T) {
    a[t] = alpha[t] - mean_alpha;
  }
}
