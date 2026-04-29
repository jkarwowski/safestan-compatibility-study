// Dyes: variance components model 
//  http://www.openbugs.net/Examples/Dyes.html

data {
  int BATCHES;
  int SAMPLES;
  vector[BATCHES * SAMPLES] y_safestan_flat;
}
parameters {
  real<lower=0> tau_between;
  real<lower=0> tau_within;
  real theta;
  array[BATCHES] real mu;
}
transformed parameters {
  real sigma_between;
  real sigma_within;
  sigma_between = 1 / sqrt(tau_between);
  sigma_within = 1 / sqrt(tau_within);
}
model {
  vector[BATCHES * SAMPLES] mu_safestan_flat;

  theta ~ normal(0.0, 1E5);
  tau_between ~ gamma(.001, .001);
  tau_within ~ gamma(.001, .001);
  
  mu ~ normal(theta, sigma_between);
  for (n in 1 : BATCHES) {
    for (s in 1 : SAMPLES) {
      mu_safestan_flat[(n - 1) * SAMPLES + s] = mu[n];
    }
  }
  y_safestan_flat ~ normal(mu_safestan_flat, sigma_within);
}
generated quantities {
  real sigmasq_between;
  real sigmasq_within;
  
  sigmasq_between = 1 / tau_between;
  sigmasq_within = 1 / tau_within;
}
