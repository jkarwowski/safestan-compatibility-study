data {
  int<lower=0> K;
  int<lower=0> T;
  array[T] real y;
  int<lower=0, upper=T> N_safestan_obs;
  array[N_safestan_obs] real y_safestan_response;
}
parameters {
  real alpha;
  array[K] real beta;
  real<lower=0> sigma;
}
model {
  alpha ~ normal(0, 10);
  beta ~ normal(0, 10);
  sigma ~ cauchy(0, 2.5);
  
  {
    array[N_safestan_obs] real mu;
    for (n in 1 : N_safestan_obs) {
      int t = K + n;
      mu[n] = alpha;
      
      for (k in 1 : K) {
        mu[n] = mu[n] + beta[k] * y[t - k];
      }
    }
    
    y_safestan_response ~ normal(mu, sigma);
  }
}
