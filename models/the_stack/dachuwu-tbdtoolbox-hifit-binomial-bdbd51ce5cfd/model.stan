data {
 int<lower=0> n_obs;
 array[n_obs] int<lower=0> isDat;
 int<lower=0> n_x;
 int<lower=0> n_h;
 array[n_h] int<lower=0> k_vect;

 matrix[n_obs, n_x] X_fix;
 array[n_obs, n_h] int X_hier;

 array[n_obs] int<lower=0> Y;
 array[n_obs] int<lower=0> pop;
 int<lower=0> pop_0;
}

transformed data{

  array[n_obs, n_h] int X_hier_pad = X_hier;
  if(n_h > 1){
    for(h in 2:n_h)
      for(i in 1:n_obs) X_hier_pad[i,h] = X_hier_pad[i,h] + sum(k_vect[1:(h-1)]);
  }

}

parameters {
  vector[n_x] b_x;
  //real a_0;
  array[sum(k_vect)] real a_h;
  array[n_h] real<lower=0> kap_a_h;
}

transformed parameters{
  array[n_obs] real eta;
  vector[n_obs] eta_x;

  eta_x =  X_fix * b_x;
  for(i in 1:n_obs){
    eta[i] = sum(a_h[X_hier_pad[i,]]) + eta_x[i];
  }
}

model {
  b_x ~ normal(0, 1);
  //a_0 ~ normal(0, 1);
  a_h[1:k_vect[1]] ~ normal(0, kap_a_h[1]);
  if(n_h > 1){
    for(h in 2:n_h)
      a_h[(sum(k_vect[1:(h-1)]) + 1) : sum(k_vect[1:h])] ~ normal(0, kap_a_h[h]);
  }
  kap_a_h ~ exponential(0.1);
  for(i in 1:n_obs){
    if(isDat[i]==1) target += binomial_logit_lpmf(Y[i] | pop[i], eta[i]);
  }
}

generated quantities{
  array[n_obs] real pos_pd;
  // for(i in 1:n_obs) prev[i] = inv_logit(eta[i]);
  for(i in 1:n_obs)
    pos_pd[i] = binomial_rng(pop_0, inv_logit(eta[i]))* 1.0/pop_0;
}
