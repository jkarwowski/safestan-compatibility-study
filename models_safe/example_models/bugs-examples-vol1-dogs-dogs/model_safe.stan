// compared with JAGS version in 
// the R package BUGSExamples (https://r-forge.r-project.org/R/?group_id=882) 
data {
  int<lower=0> Ndogs;
  int<lower=0> Ntrials;
  array[Ndogs, Ntrials] int Y;
  array[Ndogs * (Ntrials - 1)] int y_safestan;
}
transformed data {
  array[Ndogs, Ntrials] int xa;
  array[Ndogs, Ntrials] int xs;
  for (dog in 1 : Ndogs) {
    xa[dog, 1] = 0;
    xs[dog, 1] = 0;
    for (trial in 2 : Ntrials) {
      for (k in 1 : (trial - 1)) {
        xa[dog, trial] = xa[dog, trial] + Y[dog, k];
      }
      xs[dog, trial] = trial - 1 - xa[dog, trial];
    }
  }
}
parameters {
  real<upper=-0.00001> alpha;
  real<upper=-0.00001> beta;
}
model {
  vector[Ndogs * (Ntrials - 1)] p_safestan;
  alpha ~ normal(0.0, 316.2);
  beta ~ normal(0.0, 316.2);
  for (dog in 1 : Ndogs) {
    for (trial in 2 : Ntrials) {
      int n_safestan;
      n_safestan = (dog - 1) * (Ntrials - 1) + (trial - 1);
      p_safestan[n_safestan] = exp(alpha * xa[dog, trial]
                                    + beta * xs[dog, trial]);
    }
  }
  y_safestan ~ bernoulli(p_safestan);
}
generated quantities {
  real A;
  real B;
  A = exp(alpha);
  B = exp(beta);
}
