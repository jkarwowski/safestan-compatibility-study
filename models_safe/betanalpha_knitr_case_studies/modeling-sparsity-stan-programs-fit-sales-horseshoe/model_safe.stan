data {
  int<lower=0> N_obs; // Number of sales observations
  array[N_obs] int y_obs;  // Daily units sold

  int<lower=0> N_obs_days;                           // Number of days observed
  array[N_obs] int<lower=1, upper=N_obs_days> obs_day_idx; // Day of each observation

  int<lower=0> N_pred_days;                        // Number of future days to predict
  array[N_pred_days] int<lower=N_obs_days> pred_day_idx; // Day of each prediction

  vector<lower=0, upper=1>[N_obs_days] w; // Partial centering parameters
}

parameters {
  vector[N_obs_days] delta_days_tilde; // Daily excess
  vector<lower=0>[N_obs_days] lambda;  // Horseshoe inflation parameters
  real<lower=0> tau_day;        // Weekly log variation scale

  real alpha;                   // Baseline sales per day
  real<lower=0> delta_season;   // Amplitude of log seasonal variation
  real delta_phi;               // Phase of seasonal variation from 10.5 days
  real<lower=0> milli_inv_psi;  // Observational dispersion times 1000
}

transformed parameters {
  real phi = 10.5 + delta_phi;

  vector[N_obs_days] delta_days;
  for (d in 1:N_obs_days)
    delta_days[d] = pow(lambda[d] * tau_day, 1 - w[d]) * delta_days_tilde[d];
}

model {
  vector[N_obs_days] delta_days_tilde_scale;

  // Prior model
  lambda ~ cauchy(0, 1);
  tau_day ~ normal(0, log(1.1));

  for (d in 1:N_obs_days)
    delta_days_tilde_scale[d] = pow(lambda[d] * tau_day, w[d]);
  delta_days_tilde ~ normal(0, delta_days_tilde_scale);

  alpha ~ normal(log(200), log(50));
  delta_season ~ normal(0, log(1.5));
  delta_phi ~ normal(0, 1);
  milli_inv_psi ~ normal(0, 10);

  // Observational model
  y_obs
    ~ neg_binomial_2_log(  alpha
                         + delta_season * sin(2 * pi() * to_vector(obs_day_idx) / 360 + phi)
                         + delta_days[obs_day_idx], 1000 / milli_inv_psi);
}

generated quantities {
  array[N_obs_days] real log_mu;
  array[N_obs_days] int y_post_retro;
  array[N_pred_days] int y_post_pre;

  for (d in 1:N_obs_days) {
    real lm = alpha + delta_season * sin(2 * pi() * d / 360 + phi) + delta_days[d];

    // Truncate extreme samples to avoid numerical overflow
    // in neg_binomial_2_log pseudo random number generator
    if (lm > +20) lm = +20;
    if (lm < -20) lm = -20;

    log_mu[d] = lm;
    y_post_retro[d] = neg_binomial_2_log_rng(lm, 1000 / milli_inv_psi);
  }

  for (d in 1:N_pred_days) {
    real l = abs(cauchy_rng(0, 1));
    real delta_day = normal_rng(0, l * tau_day);
    real lm =   alpha
              + delta_season * sin(2 * pi() * pred_day_idx[d] / 360 + phi)
              + delta_day;

    // Truncate extreme samples to avoid numerical overflow
    // in neg_binomial_2_log pseudo random number generator
    if (lm > +20) lm = +20;
    if (lm < -20) lm = -20;

    y_post_pre[d] = neg_binomial_2_log_rng(lm, 1000 / milli_inv_psi);
  }
}
