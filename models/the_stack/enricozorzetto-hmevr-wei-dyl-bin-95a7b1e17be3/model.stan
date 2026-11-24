// The hbevm model - weibull dynamic lognormal
data {
  int<lower = 1> M; // number of years 
  int<lower = 1> Mgen; // number of years of posterior data to generate
  int<lower = 1> Nt; // number of observations /year
  array[M, Nt] real<lower=0> y; // all observed values
  array[M] int<lower=0> N;  // number of events - sample
  // real<lower=0> sigmac0prior[2]; 
  // real<lower=0> sigmaw0prior[2];
  // real muc0prior[2]; 
  // real muw0prior[2]; 
  array[2] real<lower=0> sc0prior; 
  array[2] real<lower=0> sw0prior;
  array[2] real mc0prior; 
  array[2] real mw0prior; 
  array[2] real<lower = 0> pn0prior;
}
// transformed data{
//   int<lower=0> nwets;
//   nwets = sum(N);
// }
parameters {
array[M] real<lower=0> C; 
array[M] real<lower=0> w; 
 real <lower=0> mc; // average of c 
 real <lower=0> mw; 
 real <lower=0> sc; // standard deviation of c
 real <lower=0> sw; 
  // real muc;
  // real muw;
  // real<lower = 0> sigmac;
  // real<lower = 0> sigmaw;
  real<lower=0, upper = 1> pn;
}
transformed parameters{
 // real <lower=0> mc; // average of c 
 // real <lower=0> mw; 
 // real <lower=0> sc; // standard deviation of c
 // real <lower=0> sw; 
   real muc;
  real muw;
  real<lower = 0> sigmac;
  real<lower = 0> sigmaw;
  muc = log(mc)-0.5*log1p( pow(sc/mc, 2));
  muw = log(mw)-0.5*log1p( pow(sw/mw, 2));
  sigmac = sqrt(log1p(pow(sc/mc, 2)));
  sigmaw = sqrt(log1p(pow(sw/mw, 2)));

 
}
model {
  // Priors
  pn ~ beta(pn0prior[1], pn0prior[2]);
  // muc ~ normal(muc0prior[1], muc0prior[2]); 
  // muw ~ normal(muw0prior[1], muw0prior[2]);
  // sigmac ~ inv_gamma(sigmac0prior[1], sigmac0prior[2]);
  // sigmaw ~ inv_gamma(sigmaw0prior[1], sigmaw0prior[2]);
  mw ~ inv_gamma(mw0prior[1], mw0prior[2]);
  sw ~ inv_gamma(sw0prior[1], sw0prior[2]);
  mc ~ inv_gamma(mc0prior[1], mc0prior[2]);
  sc ~ inv_gamma(sc0prior[1], sc0prior[2]);
  // Model
  C ~ lognormal(muc, sigmac);
  w ~ lognormal(muw, sigmaw);
  for (m in 1:M) {
  target += binomial_lpmf(N[m] | Nt, pn);
    for (j in 1:Nt) {
      if (y[m,j] >1e-6) { 
         y[m,j] ~ weibull( w[m], C[m]);
      }
    }
  }
}
generated quantities {
    // real log_lik[nwets]; // log like for the accumulations only (not for the N model)
  // real log_lik_N[M]; // log like for the N model only
  // real<lower=0> ygen[Mgen,Nt]; // all observed values
  // real<lower=0>maxgen[Mgen];
  array[Mgen] int<lower=0> Ngen; // all observed values
  array[Mgen] real<lower=0> Cgen; // generated yearly parameters
  array[Mgen] real<lower=0> wgen; // generated yearly parameters
  // int <lower=0> count;
  
  // count = 0;
  // for (m in 1:M){
  //   log_lik_N[m] = binomial_lpmf(N[m] | Nt, pn);
  //   for (j in 1:Nt){
  //     if (y[m,j] > 1e-6){
  //       count = count + 1;
  //       log_lik[count] = weibull_lpdf(y[m,j] | w[m], C[m]);
  //       }
  //     }
  //   }
    
for (m in 1:Mgen) {
    Cgen[m] = lognormal_rng(muc, sigmac);
    wgen[m] = lognormal_rng(muw, sigmaw);
    Ngen[m] = binomial_rng(Nt, pn);
    // for (j in 1:Nt) {
    //   if (j <= Ngen[m]) {
    //      ygen[m,j] = weibull_rng( wgen[m], Cgen[m]);
    //   } else {
    //     ygen[m,j] = 0.0;
    //   }
    // }
    // maxgen[m] = max(ygen[m]);
  }
    
    
}
