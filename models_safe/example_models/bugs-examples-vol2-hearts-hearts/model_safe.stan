/**
 * Hearts: a mixture model for count data
 * http://www.openbugs.net/Examples/Hearts.html
 * 
 * integrate out the binary parameters in hearts.stan.0 
 */
data {
  int<lower=0> N;
  int<lower=1> K;
  array[N] int<lower=0> x;
  array[N] int<lower=0, upper=K - 1> t;
  array[N] int<lower=1, upper=K> y_cat;
}
parameters {
  real alpha;
  real delta;
}
transformed parameters {
  real<lower=0, upper=1> theta;
  theta = inv_logit(delta);
}
model {
  array[N] vector[K] y_prob;

  alpha ~ normal(0, 100);
  delta ~ normal(0, 100);

  {
    real p;
    real theta_model;
    real log1m_theta;
    real log1m_p;

    p = inv_logit(alpha);
    theta_model = inv_logit(delta);
    log1m_theta = log1m(theta_model);
    log1m_p = log1m(p);

    for (i in 1 : N) {
      y_prob[i] = rep_vector(0, K);
      y_prob[i][1] = theta_model + (1 - theta_model) * exp(t[i] * log1m_p);
      if (t[i] > 0) {
        for (k in 1 : t[i]) {
          y_prob[i][k + 1] = exp(log1m_theta + lchoose(t[i], k)
                                  + k * log(p) + (t[i] - k) * log1m_p);
        }
      }
    }
  }

  y_cat ~ categorical(y_prob);
}
generated quantities {
  real beta;
  beta = exp(alpha);
}
