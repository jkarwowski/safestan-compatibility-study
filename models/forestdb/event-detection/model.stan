// ForestDB translation: Event Detection
data {
  int<lower=1> T;
  array[T] int<lower=0> counts;
}
parameters {
  real<lower=0> lambda_low;
  real<lower=0> lambda_high;
}
model {
  vector[T] lp_change;
  lambda_low ~ gamma(2, 1);
  lambda_high ~ gamma(2, 0.5);
  for (s in 1:T) {
    lp_change[s] = -log(T);
    for (t in 1:T) {
      lp_change[s] += poisson_lpmf(counts[t] | t <= s ? lambda_low : lambda_high);
    }
  }
  target += log_sum_exp(lp_change);
}
generated quantities {
  real rate_ratio = lambda_high / lambda_low;
}
