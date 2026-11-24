data { 
  int<lower=0> N;
  array[N] int<lower=0> t;
  array[N] real<lower=0> y;
} 
parameters {
  real<lower=0> mu;
  real<lower=0> sigma;
  real<lower=0> alpha;
  real beta;
} 
model {
  alpha ~ gamma(1,0.05);
  for (n in 1:N) 
    y[n] ~ student_t(alpha, mu + t[n] * beta, sigma);
}
generated quantities{
  array[N] real y_pred;
  for (n in 1:N)
    y_pred[n] = student_t_rng(alpha, mu + t[n] * beta, sigma);
}
