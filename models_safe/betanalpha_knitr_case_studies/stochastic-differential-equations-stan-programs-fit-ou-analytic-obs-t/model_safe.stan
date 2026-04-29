data {
  real t0;

  int<lower=1> N_obs;
  array[N_obs] real t_obs;
  vector[N_obs] y_obs;
  real<lower=0> sigma;
}

parameters {
  real mu;
  real<lower=0> gamma;
  real<lower=0> tau;

  real x0;
  vector[N_obs] x;
}

model {
  real decay;
  real innovation_var;
  vector[N_obs] x_mean;
  matrix[N_obs, N_obs] x_cov;

  mu ~ normal(0, 10);
  gamma ~ normal(0, 1);
  tau ~ normal(0, 1);

  x0 ~ normal(0, 3);

  x_cov = rep_matrix(0, N_obs, N_obs);

  decay = exp(-gamma * (t_obs[1] - t0));
  x_mean[1] = mu + (x0 - mu) * decay;
  innovation_var = square(0.7071 * tau) * (1 - decay) / gamma;
  x_cov[1, 1] = innovation_var;

  for (n in 2:N_obs) {
    decay = exp(-gamma * (t_obs[n] - t_obs[n - 1]));
    x_mean[n] = mu + (x_mean[n - 1] - mu) * decay;
    innovation_var = square(0.7071 * tau) * (1 - decay) / gamma;

    for (m in 1:(n - 1)) {
      x_cov[n, m] = decay * x_cov[n - 1, m];
      x_cov[m, n] = x_cov[n, m];
    }

    x_cov[n, n] = square(decay) * x_cov[n - 1, n - 1] + innovation_var;
  }

  x ~ multi_normal(x_mean, x_cov);

  y_obs ~ normal(x, sigma);
}
