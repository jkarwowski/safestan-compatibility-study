// ForestDB translation: Learning from Social and Direct Evidence
data {
  int<lower=1> H;
  int<lower=1> N;
  matrix<lower=0, upper=1>[N, H] likelihood;
}
parameters {
  simplex[H] hypothesis_weight;
}
model {
  hypothesis_weight ~ dirichlet(rep_vector(1.0, H));
  for (n in 1:N) {
    vector[H] lp;
    for (h in 1:H) {
      lp[h] = log(hypothesis_weight[h]) + log(likelihood[n, h]);
    }
    target += log_sum_exp(lp);
  }
}
generated quantities {
  simplex[H] posterior_hypothesis = hypothesis_weight;
}
