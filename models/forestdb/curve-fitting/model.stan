// ForestDB translation: Curve Fitting
data {
  int<lower=1> R;
  int<lower=1> N;
  vector[N] x;
  vector[N] y;
  matrix[R, N] rule_pred;
}
parameters {
  simplex[R] rule_weight;
  real<lower=0> sigma;
}
model {
  rule_weight ~ dirichlet(rep_vector(1.0, R));
  sigma ~ lognormal(-1, 0.5);
  for (n in 1:N) {
    vector[R] lp;
    for (r in 1:R) {
      lp[r] = log(rule_weight[r]) + normal_lpdf(y[n] | rule_pred[r, n], sigma);
    }
    target += log_sum_exp(lp);
  }
}
generated quantities {
  int<lower=1, upper=R> map_rule = categorical_rng(rule_weight);
}
