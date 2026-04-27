data {
  int<lower=1> N;
  vector[N] x;
  vector[N] y;
}
parameters {
  real alpha_linear;
  real beta_linear;
  real<lower=0> sigma_linear;
  real alpha_quad;
  real beta_quad;
  real gamma_quad;
  real<lower=0> sigma_quad;
  real<lower=0, upper=1> p_linear;
}
model {
  alpha_linear ~ normal(0, 5);
  beta_linear ~ normal(0, 5);
  sigma_linear ~ lognormal(0, 1);
  alpha_quad ~ normal(0, 5);
  beta_quad ~ normal(0, 5);
  gamma_quad ~ normal(0, 5);
  sigma_quad ~ lognormal(0, 1);
  p_linear ~ beta(1, 1);
  {
    real lp_linear = log(p_linear);
    real lp_quad = log1m(p_linear);
    for (n in 1 : N) {
      lp_linear += normal_lpdf(y[n] | alpha_linear + beta_linear * x[n], sigma_linear);
      lp_quad += normal_lpdf(y[n] | alpha_quad + beta_quad * x[n]
                                    + gamma_quad * square(x[n]), sigma_quad);
    }
    target += log_sum_exp(lp_linear, lp_quad);
  }
}
generated quantities {
  real posterior_linear_prob;
  {
    real lp_linear = log(p_linear);
    real lp_quad = log1m(p_linear);
    for (n in 1 : N) {
      lp_linear += normal_lpdf(y[n] | alpha_linear + beta_linear * x[n], sigma_linear);
      lp_quad += normal_lpdf(y[n] | alpha_quad + beta_quad * x[n]
                                    + gamma_quad * square(x[n]), sigma_quad);
    }
    posterior_linear_prob = exp(lp_linear - log_sum_exp(lp_linear, lp_quad));
  }
}
