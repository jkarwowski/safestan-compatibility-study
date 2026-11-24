data{
 int<lower=0> N;
 array[N] int y;
}

parameters {
  ordered[2] mu;
  array[2] real<lower=0> sigma;
  real<lower=0, upper=1> theta;
  array[2] vector[N] log_lambda;
}
model {
 sigma ~ cauchy(0, 2.5);
 mu ~ normal(0, 10);
 theta ~ beta(2, 2);
 for (i in 1:2)
  log_lambda[i,] ~ normal(mu[i], sigma[i]);
 for (n in 1:N)
  target += log_mix(theta,
                    poisson_log_lpmf(y[n] | log_lambda[1, n]),
                    poisson_log_lpmf(y[n] | log_lambda[2, n]));
}
