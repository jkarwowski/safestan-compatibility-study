data {
  int J;
  array[J] int n;
  vector[J] x;
  array[J] int y;
  real r;
  real R;
  real overshot;
  real distance_tolerance;
  vector[J] raw_proportions;
}
transformed data {
  vector[J] threshold_angle = asin((R - r) ./ x);
}
parameters {
  real<lower=0> sigma_angle;
  real<lower=0> sigma_distance;
  real<lower=0> sigma_y;
}
model {
  vector[J] p_angle;
  vector[J] p_distance;
  vector[J] p;

  sigma_angle ~ normal(0, 1);
  sigma_distance ~ normal(0, 1);
  sigma_y ~ normal(0, 1);

  p_angle = 2 * Phi(threshold_angle / sigma_angle) - 1;
  p_distance = Phi((distance_tolerance - overshot)
                   ./ ((x + overshot) * sigma_distance))
               - Phi((-overshot)
                     ./ ((x + overshot) * sigma_distance));
  p = p_angle .* p_distance;
  raw_proportions ~ normal(p,
                           sqrt(p .* (1 - p) ./ to_vector(n) + sigma_y ^ 2));
}
generated quantities {
  real sigma_degrees = sigma_angle * 180 / pi();
}
