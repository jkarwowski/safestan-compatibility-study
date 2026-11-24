functions {
  real count_series_lp(array[] int y, array[] int off,
      vector delta, real alpha, real beta, // ACP part
      real gamma, real eta, real phi) {  // zero-inflation part

    real lp;
    int Y;
    vector[size(y)] mu;
    vector[size(y)] omega;
    vector[size(y)] theta;
    array[size(y)] int value;

    Y = size(y);

    for(i in 1:Y) {
      if(y[i] == 0) {
        value[i] = 1;
      } else {
        value[i] = 0;
      }
    }

    omega[1] = phi;
    for(i in 2:Y) {
      omega[i] = exp(delta[1] + delta[2] * i);
    }

    // ACP part
    mu[1] = omega[1];
    for(i in 2:Y) {
      mu[i] = omega[i] + alpha * y[i - 1] + beta * mu[i - 1];
    }

    // zero-inflated part
    theta[1] = 0;
    for(i in 2:Y) {
      theta[i] = (value[i - 1] * gamma) + ((1 - value[i - 1]) * eta);
    }

    lp = 0;
    for(i in 1:Y) {
      if(y[i] == 0) {
        lp = lp + log_sum_exp(bernoulli_lpmf(1 | theta[i]), 
            bernoulli_lpmf(0 | theta[i]) + 
            poisson_lpmf(y[i] | (off[i] + 1) * mu[i]));
      } else {
        lp = lp + (bernoulli_lpmf(0 | theta[i]) + 
            poisson_lpmf(y[i] | (off[i] + 1) * mu[i]));
      }
    }
    return lp;
  }
}
data {
  int<lower=0> N;
  int<lower=0> P;
  array[P] int<lower=0> str;
  array[P] int<lower=0> end;
  array[P, N] int<lower=0> counts;
  array[P, N] int<lower=0> off;
}
parameters {
  array[P] vector[2] delta;
  vector[2] mu;
  corr_matrix[2] Omega;
  vector<lower=0>[2] sigma;
  array[P] real<lower=0,upper=1> alpha;
  array[P] real<lower=0,upper=1> beta_unc;
  array[P] real<lower=0,upper=1> gamma;
  array[P] real<lower=0,upper=1> eta;

  array[P] real<lower=0> phi; // param at t = 1
  real mu_phi; // param at t = 1
  real<lower=0> sigma_phi; // param at t = 1
}
transformed parameters {
  array[P] real<lower=0,upper=1> beta;
  cov_matrix[2] Sigma;

  for(p in 1:P) {
    beta[p] = (1 - alpha[p]) * beta_unc[p];
  }

  Sigma = quad_form_diag(Omega, sigma);
}
model {
  for(p in 1:P) {
    alpha[p] ~ beta(1, 3);
    beta_unc[p] ~ beta(1, 3);
  }

  phi ~ lognormal(mu_phi, sigma_phi);
  mu_phi ~ normal(0, 1);
  sigma_phi ~ cauchy(0, 1);

  Omega ~ lkj_corr(2);
  sigma ~ cauchy(0, 1);
  mu[1] ~ normal(0, 5);
  mu[2] ~ normal(0, 1);
  for(p in 1:P) {
    delta[p] ~ multi_normal(mu, Sigma);
  }

  for(p in 1:P) {
    target += count_series_lp(counts[p][str[p]:end[p]],
        off[p][str[p]:end[p]], 
        delta[p], alpha[p], beta[p], gamma[p], eta[p], phi[p]);
  }
}
