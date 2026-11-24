data {
   int<lower=0> N;  // number of obs
   int<lower=0> N_ID; // number of subjects
   array[N] real y;  // reaction times
   array[N] real x;  // days
   array[N] int id;  // subject IDs
}

transformed data {
   vector[N] centered_x;
   real mean_x;
   mean_x = mean(x);
   for (i in 1:N){
     centered_x[i] = x[i] - mean_x;
   }
}

parameters {
   array[N_ID] real alpha_star;
   array[N_ID] real beta;
   real<lower=0> sig2;
   real<lower=0> tau2_alpha;
   real<lower=0> tau2_beta;
}

transformed parameters {
   vector[N] linpred;
   for (i in 1:N){
     linpred[i] = alpha_star[id[i]] + beta[id[i]]*centered_x[i];
   }
}

model {
   sig2 ~ inv_gamma(0.001, 0.001);
   tau2_alpha ~ inv_gamma(0.001, 0.001);
   tau2_beta ~ inv_gamma(0.001, 0.001);
   for (j in 1:N_ID){
      alpha_star[j] ~ normal(300, tau2_alpha);
      beta[j] ~ normal(10, tau2_beta);
   }
   for (i in 1:N){
     y[i] ~ normal(linpred[i], sig2);
     }
}

generated quantities {
   array[N_ID] real alpha;
   for (j in 1:N_ID) {
      alpha[j] = alpha_star[j] - beta[j]*mean_x;
   }
}
