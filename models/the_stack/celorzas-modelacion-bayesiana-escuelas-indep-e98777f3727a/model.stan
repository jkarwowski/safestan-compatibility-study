data {
  int<lower=0> J;
  array[J] real y;
  array[J] real<lower=0> sigma;
}
parameters {
  array[J] real theta;
}
model {
  y ~ normal(theta, sigma);
}
generated quantities {
  array[J] real log_lik;
  for (jj in 1:J){
    log_lik[jj] = normal_lpdf(y[jj] | theta[jj], sigma[jj]);
  }
}
