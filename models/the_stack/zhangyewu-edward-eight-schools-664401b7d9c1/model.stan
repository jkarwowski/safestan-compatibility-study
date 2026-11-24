data {
  int<lower=0> J;
  array[J] real y;
  array[J] real<lower=0> sigma;
}

parameters {
  real mu;
  real logtau;
  array[J] real theta_prime;
}

model {
  mu ~ normal(0, 10); 
  logtau ~ normal(5, 1);
  theta_prime ~ normal(0, 1);
  for (j in 1:J) {
      y[j] ~ normal(mu + exp(logtau) * theta_prime[j], sigma[j]);
  }
}
