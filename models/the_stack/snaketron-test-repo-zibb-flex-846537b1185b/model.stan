functions {
  real zibb_lpmf(int y, int trials, real a, real b, real zi) {
    if (y == 0) {
      return log_sum_exp(bernoulli_lpmf(1 | zi),
                         bernoulli_lpmf(0 | zi) +
                         beta_binomial_lpmf(0 | trials, a, b));
    } else {
      return bernoulli_lpmf(0 | zi) +
             beta_binomial_lpmf(y | trials, a, b);
    }
  }

  int zibb_rng(int y, int trials, real a, real b, real zi) {
    if (bernoulli_rng(zi) == 1) {
      return (0);
    } else {
      return (beta_binomial_rng(trials, a, b));
    }
  }
}


data {
  int <lower = 0> N_sample; // number of samples (repertoires)
  int <lower = 0> N_gene; // number of genes
  array[N_gene, N_sample] int Y; // number of successes (cells) in samples x gene
  array[N_sample] int N; // number of total tries (repertoire size)
  array[N_sample] int<lower = -1, upper = 1> X; // condition
}


transformed data {
  // convert int N -> real N fo convenient division
  // in generated quantities block
  array[N_sample] real Nreal;
  Nreal = N;
}


parameters {
  real <lower = 0> alpha_sigma;
  real <lower = 0> beta_sigma;
  real <lower = 0> alpha_gene_sigma;
  real <lower = 0> beta_gene_sigma;
  array[N_sample] vector[N_gene] alpha_raw;
  array[N_sample] vector[N_gene] beta_raw;
  vector [N_gene] alpha_gene_raw;
  vector [N_gene] beta_gene_raw;
  real <lower = 0> phi;
  real<lower = 0> tau;
  // zero-inflation probability
  vector <lower = 0, upper = 1> [N_gene] z;
  real<lower=0> z_mu;
  real<lower=0> z_phi;
}



transformed parameters {
  array[N_sample] vector[N_gene] alpha;
  array[N_sample] vector[N_gene] beta;
  vector [N_gene] alpha_gene;
  vector [N_gene] beta_gene;
  array[N_sample] vector<lower = 0>[N_gene] a;
  array[N_sample] vector<lower = 0>[N_gene] b;
  
  // non-centered params (at repertoire level)
  alpha_gene = 0 + alpha_gene_sigma * alpha_gene_raw;
  beta_gene = 0 + beta_gene_sigma * beta_gene_raw;

  // non-centered params (at gene level)
  for(i in 1:N_sample) {
    beta[i] = beta_gene + beta_sigma * beta_raw[i];
    alpha[i] = alpha_gene + alpha_sigma * alpha_raw[i];
    a[i] = inv_logit(alpha[i] + beta[i]*X[i]) * phi;
    b[i] = phi - a[i];
  }
}


model {
  for(i in 1:N_sample) {
    for(j in 1:N_gene) {
      // likelihood: TODO speedup
      target += zibb_lpmf(Y[j, i] | N[i], a[i][j], b[i][j], z[j]);
    }
  }

  // priors
  alpha_sigma ~ cauchy(0, 1);
  beta_sigma ~ cauchy(0, 1);
  
  alpha_gene_sigma ~ cauchy(0, 1);
  beta_gene_sigma ~ cauchy(0, 1);

  for(i in 1:N_sample) {
    alpha_raw[i] ~ std_normal();
    beta_raw[i] ~ std_normal();
  }
  alpha_gene_raw ~ std_normal();
  beta_gene_raw ~ std_normal();

  phi ~ exponential(tau); //pareto 2
  tau ~ gamma(3, 0.1);
  
  // zero-inflation hyperpriors
  z ~ beta(z_phi * z_mu, z_phi * (1 - z_mu));
  z_mu ~ beta(1.0, 3.0);
  z_phi ~ exponential(0.1);
}


generated quantities {
  // PPC: count usage
  array[N_gene, N_sample] int Yhat;

  // PPC: proportion usage
  array[N_gene, N_sample] real Yhat_individual;

  // PPC: proportion usage at a gene level
  matrix [2, N_gene] Yhat_gene;

  // LOG-LIK
  array[N_sample] vector[N_gene] log_lik;

  //TODO: speedup, run in C++ not big factor on performance
  for(j in 1:N_gene) {
    for(i in 1:N_sample) {
      log_lik[i][j] = zibb_lpmf(Y[j, i] | N[i], a[i][j], b[i][j], z[j]);
      Yhat[j, i] = zibb_rng(Y[j, i], N[i], a[i][j], b[i][j], z[j]);

      if(Nreal[i] == 0.0) {
        Yhat_individual[j, i] = 0;
      }
      else {
        Yhat_individual[j, i] = Yhat[j,i]/Nreal[i];
      }
    }
    Yhat_gene[1, j] = inv_logit(alpha_gene[j]+beta_gene[j]*1.0);
    Yhat_gene[2, j] = inv_logit(alpha_gene[j]+beta_gene[j]*(-1.0));
  }
}
