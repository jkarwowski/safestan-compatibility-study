//**** Three component model ****
// This model assumes a univariate normal distribution for *disease*
// and a mixture of two normals as the distribution for *not disease*
data {
   int N;                                // number of patients
   int Ntest;                            // number of tests
   array[N] vector[Ntest] y;                   // data
   int<lower=0> K_sites;                 // number of different sites (populations)
   array[N] int<lower=1,upper=K_sites> site;   // index of sites for each patient
   array[Ntest] vector[3] prior_mu;            // prior on mixture mean values
   array[Ntest] vector[3] prior_sigma_mu;      // prior on mixture mean values
   array[K_sites] vector[3] alpha_prior;       // prior on mixtures
   array[Ntest, 3] int<lower=1,upper=3> cluster;
}

parameters {
   array[K_sites] simplex[3] theta;   //
   array[Ntest] ordered[3] mu;
   array[Ntest] vector<lower=0>[3] sigma;
}

model {
   // **** Prior **** //
   for(t in 1:Ntest){
      for(i in 1:3){
         mu[t][i] ~ normal(prior_mu[t][i],prior_sigma_mu[t][i]);
         sigma[t][i] ~ exponential(2);
      }
   }
   for(ks in 1:K_sites){
      theta[ks] ~ dirichlet(alpha_prior[ks]);
   }

   // **** Likelihood **** //
   for(n in 1:N){
      int k = site[n];
      vector[3] ps;
      // loop over each sub-distribution in the mixture
      for(i in 1:3){
         ps[i]=log(theta[k][i]);
         for(t in 1:Ntest){
            ps[i] += normal_lpdf(y[n][t] | mu[t][cluster[t,i]], sigma[t][cluster[t,i]]);
         }
      }
      target += log_sum_exp(ps);
   }

}

generated quantities {
   array[N] real<lower=0> ps_SM;
   array[N] vector<lower=0>[3] ps_comp;
   // This computes respective densities of each mixture component
   for(n in 1:N){
      int k = site[n];
      for(i in 1:3){
         ps_comp[n][i]=theta[k][i];
         for(t in 1:Ntest){
            ps_comp[n][i] *= exp(normal_lpdf(y[n][t] | mu[t][cluster[t,i]], sigma[t][cluster[t,i]]));
         }
      }
      // normalise to get P_SM
      ps_comp[n] = ps_comp[n]/sum(ps_comp[n]);
      ps_SM[n] = ps_comp[n][1];
   }
}
