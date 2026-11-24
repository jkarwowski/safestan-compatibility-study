// This model assumes two normal distributions (one for disease/one for not disease)
data {
   int N;                                // number of patients
   int Ntest;                            // number of tests
   array[N] vector[Ntest] y;                   // data
   array[Ntest] vector[2] prior_mu;
   array[Ntest] vector<lower=0>[2] prior_mu_sigma;
   int<lower=0> K_sites;                 // number of different sites (populations)
   array[N] int<lower=1,upper=K_sites> site;   // index of sites for each patient
   array[K_sites] vector[2] beta_prior_prev;
}
parameters {
   array[K_sites] real<lower=0,upper=1> prev;   //mixing proportions
   array[Ntest] ordered[2] mu_test;
   array[2] vector<lower=0>[Ntest] sigma;
}
transformed parameters{
   array[2] vector[Ntest] mu;
   for(t in 1:2){
      for(i in 1:Ntest){
         mu[t][i] = mu_test[i][t];
      }
   }
}

model {
   // **** Prior **** //
   for(i in 1:2){
      sigma[i] ~ normal(.5, .5);
   }
   for(ks in 1:K_sites){
      prev[ks] ~ beta(beta_prior_prev[ks][1],beta_prior_prev[ks][2]);
   }
   for(i in 1:Ntest){
      mu_test[i] ~ normal(prior_mu[i], prior_mu_sigma[i]);
   }

   // **** Likelihood **** //
   for(n in 1:N){
      int k = site[n];
      real p1 = log1m(prev[k]);
      real p2 = log(prev[k]);
      // group 1 is notSM; group 2 is SM
      for(t in 1:Ntest){
         p1 += normal_lpdf(y[n][t] | mu[1][t], sigma[1][t]);
         p2 += normal_lpdf(y[n][t] | mu[2][t], sigma[2][t]);
      }
      target += log_sum_exp(p1,p2);
   }

}

generated quantities {
   array[N] real ps_SM;
   // This computes respective densities of each mixture component
   for(n in 1:N){
      int k = site[n];
      real p1 = 1-prev[k];
      real p2 = prev[k];
      for(t in 1:Ntest){
         p1 = p1*exp(normal_lpdf(y[n][t] | mu[1][t], sigma[1][t]));
         p2 = p2*exp(normal_lpdf(y[n][t] | mu[2][t], sigma[2][t]));
      }
      // normalise to get P_SM
      ps_SM[n] = p2/(p1+p2);
   }
}

