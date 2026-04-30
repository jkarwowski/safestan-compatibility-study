data {
  int num_measurements;
  array[num_measurements] int<lower=1> measurement_times;
  vector<lower=0>[num_measurements] expression;
  vector<lower=0>[num_measurements] expression_safestan_copy;

  real<lower=0> measurement_sigma_relative;
  real<lower=0> measurement_sigma_absolute;

  real<lower = 0> initial_condition_prior_sigma;
  real<lower = 0> asymptotic_normalized_state_prior_sigma;
  real degradation_prior_mean;
  real<lower = 0> degradation_prior_sigma;
}

transformed data {
  real<lower=0> max_expression = max(expression_safestan_copy);
}

parameters {
  real<lower=0> initial_condition;
  real<lower=0> asymptotic_normalized_state;
  real<lower=0> degradation;
}


transformed parameters {
  vector<lower=0>[num_measurements] predicted_expression;
  real<lower=0> synthesis_over_degradation = asymptotic_normalized_state * max_expression;

  {
    for(t in 1:num_measurements) {
      predicted_expression[t] = synthesis_over_degradation + exp(-degradation * measurement_times[t]) * (initial_condition - synthesis_over_degradation);
    }
  }
}

model {
  initial_condition ~ normal(0, initial_condition_prior_sigma);
  asymptotic_normalized_state ~ normal(0, asymptotic_normalized_state_prior_sigma);
  degradation ~ lognormal(degradation_prior_mean, degradation_prior_sigma);

  // Observation model
  {
    vector[num_measurements] sigma;
    sigma = measurement_sigma_absolute + measurement_sigma_relative * predicted_expression;
    expression ~ normal(predicted_expression, sigma) T[0, ];
  }
}

generated quantities {
  vector<lower=0>[num_measurements] expression_replicates;
  vector[num_measurements] log_likelihood;

  for(m in 1:num_measurements) {
    real sigma = measurement_sigma_absolute + measurement_sigma_relative * predicted_expression[m];
    //Draw from the truncated normal
    real lower_bound = 0;
    real p = normal_cdf(lower_bound | predicted_expression[m], sigma);
    real u = uniform_rng(p, 1);
    expression_replicates[m] = inv_Phi(u) * sigma + predicted_expression[m];

    log_likelihood[m] = normal_lpdf(expression[m] | predicted_expression[m], sigma) - normal_lccdf(lower_bound | predicted_expression[m], sigma);
  }
}
