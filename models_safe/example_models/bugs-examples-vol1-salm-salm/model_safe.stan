//#  http://www.openbugs.net/Examples/Salm.html
//#  this matches the jags implementation
data {
  int<lower=0> Ndoses;
  int<lower=0> Nplates;
  array[Ndoses, Nplates] int<lower=0> y;
  array[Ndoses] real x;
}
transformed data {
  array[Ndoses] real logx;
  real mean_x;
  real mean_logx;
  array[Ndoses] real centered_x;
  array[Ndoses] real centered_logx;
  
  mean_x = mean(x);
  for (dose in 1 : Ndoses) {
    centered_x[dose] = x[dose] - mean_x;
  }
  
  for (dose in 1 : Ndoses) {
    logx[dose] = log(x[dose] + 10);
  }
  mean_logx = mean(logx);
  for (dose in 1 : Ndoses) {
    centered_logx[dose] = logx[dose] - mean_logx;
  }
}
parameters {
  real alpha_star;
  real beta;
  real gamma;
  real<lower=0> tau;
  array[Ndoses, Nplates] real lambda;
}
transformed parameters {
  real<lower=0> sigma;
  real alpha;
  
  alpha = alpha_star - beta * mean_logx - gamma * mean_x;
  sigma = 1.0 / sqrt(tau);
}
model {
  array[Ndoses, Nplates] real eta;

  alpha_star ~ normal(0.0, 1.0E3);
  beta ~ normal(0.0, 1000);
  gamma ~ normal(0.0, 1000);
  tau ~ gamma(0.001, 0.001);
  lambda ~ normal(0.0, sigma);

  for (dose in 1 : Ndoses) {
    for (plate in 1 : Nplates) {
      eta[dose, plate] = alpha_star + beta * centered_logx[dose]
                         + gamma * centered_x[dose] + lambda[dose, plate];
    }
  }
  y ~ poisson_log(eta);
}
