// Cervix: case - control study with errors in covariates 
//  http://www.openbugs.net/Examples/Cervix.html

// from the JAGS readme in classic-bugs/vol2/cervix:

//# ``The epidemiology in this example is a little out of date. It is now known
//#   that Human Papillomavirus (HPV) is a necessary cause of cervical cancer.
//#   Although HSV-2 may have a role as a cofactor in some cases, trying to
//#   model its effect on cervical cancer without taking into account HPV is
//#   rather pointless.'' 

//# In this version, the binary missing x's are integrated out. 

data {
  int<lower=0> Nc;
  int<lower=0> Ni;
  array[Nc] int xc;
  array[Nc] int wc;
  array[Nc] int dc;
  array[Ni] int wi;
  array[Ni] int di;
}
parameters {
  array[2, 2] real<lower=0, upper=1> phi;
  real<lower=0, upper=1> q;
  real beta0C;
  real beta;
  // note that xi is discrete parameters with support {0, 1} 
  // integrated out here 
  //int xi[Ni]; 
}
model {
  q ~ uniform(0, 1);
  beta0C ~ normal(0, 320);
  beta ~ normal(0, 320);
  phi ~ uniform(0, 1);

  xc ~ bernoulli(q);

  {
    vector[Nc] dc_logit;
    for (n in 1 : Nc) {
      dc_logit[n] = beta0C + beta * xc[n];
    }
    dc ~ bernoulli_logit(dc_logit);
  }

  {
    vector[Nc] wc_prob;
    for (n in 1 : Nc) {
      wc_prob[n] = phi[xc[n] + 1, dc[n] + 1];
    }
    wc ~ bernoulli(wc_prob);
  }

  {
    real di_prob;
    di_prob = inv_logit(beta0C + beta) * q + inv_logit(beta0C) * (1 - q);
    di ~ bernoulli(di_prob);
  }

  {
    vector[Ni] wi_prob;
    for (n in 1 : Ni) {
      wi_prob[n] = phi[1, di[n] + 1] * (1 - q) + phi[2, di[n] + 1] * q;
    }
    wi ~ bernoulli(wi_prob);
  }
}
generated quantities {
  real gamma1;
  real gamma2;
  // calculate gamma1 = P(x=1|d=0) and gamma2 = P(x=1|d=1) 
  gamma1 = 1
           / (1 + (1 + exp(beta0C + beta)) / (1 + exp(beta0C)) * (1 - q) / q);
  gamma2 = 1
           / (1
              + (1 + exp(-beta0C - beta)) / (1 + exp(-beta0C)) * (1 - q) / q);
}
