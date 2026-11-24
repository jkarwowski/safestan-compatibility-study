data { int N;
  array[N] real change;
  array[N] real female; 
  array[N] real treatment;
  }
parameters {
  real alpha;
  real beta_female;
  real beta_treatment;
  real beta_interaction;
  real<lower = 0> sigma;
} 
model {
  // priors probably need more thought:
  beta_female ~ cauchy(0,2.5);
  beta_treatment ~ cauchy(0,2.5);
  beta_interaction ~ cauchy(0,2.5);
  sigma ~ cauchy(0,2.5);
  
  for (n in 1:N) {
    change[n] ~ normal(alpha + beta_female * female[n] + beta_treatment * treatment[n] + beta_interaction * female[n] * treatment[n], sigma);
  } }
generated quantities {
  array[N] real change_ppc;
  for (n in 1:N) {
    change_ppc[n] = normal_rng(alpha + beta_female * female[n] + beta_treatment * treatment[n] + beta_interaction * female[n] * treatment[n], sigma);
  }
}
