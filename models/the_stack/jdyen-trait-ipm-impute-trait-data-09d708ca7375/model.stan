data {
  int<lower=0> n;
  vector[n] y;
  int<lower=0> nsp;
  int<lower=0> ntrait;
  int<lower=0> nlatent;
  int<lower=0> ngen;
  int<lower=0> nfam;
  array[n] int<lower=0> sp;
  array[n] int<lower=0> trait;
  array[nsp] int<lower=0> gen;
  array[ngen] int<lower=0> fam;
}

parameters {
  matrix[ntrait, nlatent] v;
  array[nfam] vector[nlatent] u_fam;
  real<lower=0> sd_main;
  real<lower=0> sigma_sp;
  real<lower=0> sigma_gen;
  real<lower=0> sigma_fam;
  real<lower=0> sigma_v;
  array[nsp] vector[nlatent] eps_sp;
  array[ngen] vector[nlatent] eps_gen;
}

transformed parameters {
  vector[n] mu;

  for (i in 1:n)
    mu[i] = v[trait[i], ] * (u_fam[fam[gen[sp[i]]]] + sigma_gen * eps_gen[gen[sp[i]]] + sigma_sp * eps_sp[sp[i]]);

}

model {
  y ~ lognormal(mu, sd_main);

  for (i in 1:nsp)
    eps_sp[i] ~ normal(0.0, 1.0);
  for (i in 1:ngen)
    eps_gen[i] ~ normal(0.0, 1.0);
  for (i in 1:nfam)
    u_fam[i] ~ normal(0.0, sigma_fam);
  to_vector(v) ~ normal(0.0, sigma_v);

  sd_main ~ normal(0.0, 10.0);
  sigma_sp ~ normal(0.0, 10.0);
  sigma_gen ~ normal(0.0, 10.0);
  sigma_fam ~ normal(0.0, 10.0);
  sigma_v ~ normal(0.0, 10.0);
}

generated quantities{
  vector[n] log_lik;
  vector[n] y_fitted;
  matrix[nsp, ntrait] trait_mat;

  for (i in 1:n)
    log_lik[i] = lognormal_lpdf(y[i] | mu[i], sd_main);

  for (i in 1:n)
    y_fitted[i] = exp(mu[i]);

  for (i in 1:nsp)
    for (j in 1:ntrait)
      trait_mat[i, j] = exp(v[j, ] * (u_fam[fam[gen[i]], ] + sigma_gen * eps_gen[gen[i]] + sigma_sp * eps_sp[i]));

}
