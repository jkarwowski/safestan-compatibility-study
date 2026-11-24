data {
  int<lower=1> nSubj;
      int<lower=1> nStim;
      array[nStim] real xs;
      array[nSubj, nStim] real<lower=0,upper=100> responses;
}

parameters {
   array[nSubj] real<lower=-.5,upper=.5> M;
      array[nSubj] real<lower=0,upper=1> SD;
      array[nSubj] real<lower=1,upper=100> height;
      real<lower=0> noise;
      array[nSubj, nStim] real predR;
      real<lower=-.5,upper=.5> M_group;
      real<lower=0,upper=1> SD_group;
      real<lower=1,upper=100> height_group;
}

transformed parameters {
   matrix[nSubj,nStim] gausFunc;
  
    for (subj in 1:nSubj) {
      for (stim in 1:nStim) {
        gausFunc[subj,stim] = height[subj] * exp(1)^-(square(xs[stim]-M[subj])/(2*square(SD[subj])));
      }
    }
}

model {
   // likelihood
    for (subj in 1:nSubj) {
      for (stim in 1:nStim) {
        responses[subj,stim] ~ normal(gausFunc[subj,stim], noise);
        predR[subj,stim] ~ normal(gausFunc[subj,stim], noise);
        M[subj] ~ normal(M_group, .5);
        SD[subj] ~ normal(SD_group, .5);
        height[subj] ~ normal(height_group, 10);
    }
   // group priors
      M_group ~ normal(0,.25)T[-.5,.5];
      SD_group ~ gamma(1.5, 1.5)T[0,1]; 
      height_group ~ normal(75, 10)T[1,100];
      noise ~ normal(0,5)T[0,];
      }
}

generated quantities {
   array[nSubj, nStim] real log_lik;
    for (subj in 1:nSubj) {
      for (stim in 1:nStim) {
        log_lik[subj,stim] = normal_lpdf(responses[subj,stim] | gausFunc[subj,stim], noise);
      }
    }
}
