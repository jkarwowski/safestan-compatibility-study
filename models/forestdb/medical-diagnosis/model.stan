data {
  int<lower=1> T;
  array[T] int<lower=0, upper=1> test_pos;
}
parameters {
  real<lower=0, upper=1> prevalence;
  vector<lower=0, upper=1>[T] sensitivity;
  vector<lower=0, upper=1>[T] specificity;
}
model {
  prevalence ~ beta(2, 8);
  sensitivity ~ beta(8, 2);
  specificity ~ beta(9, 1.5);
  {
    real lp_disease = log(prevalence);
    real lp_no_disease = log1m(prevalence);
    for (t in 1 : T) {
      lp_disease += bernoulli_lpmf(test_pos[t] | sensitivity[t]);
      lp_no_disease += bernoulli_lpmf(test_pos[t] | 1 - specificity[t]);
    }
    target += log_sum_exp(lp_disease, lp_no_disease);
  }
}
generated quantities {
  real posterior_disease_prob;
  {
    real lp_disease = log(prevalence);
    real lp_no_disease = log1m(prevalence);
    for (t in 1 : T) {
      lp_disease += bernoulli_lpmf(test_pos[t] | sensitivity[t]);
      lp_no_disease += bernoulli_lpmf(test_pos[t] | 1 - specificity[t]);
    }
    posterior_disease_prob = exp(lp_disease - log_sum_exp(lp_disease, lp_no_disease));
  }
}
