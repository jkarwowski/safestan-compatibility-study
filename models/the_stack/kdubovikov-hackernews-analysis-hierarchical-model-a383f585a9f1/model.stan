data {
  int<lower=0> N;       // number of observations
  array[N] int<lower=0> year; // year hierarchy level
  array[N] int<lower=0> day;  // day hierarchy level
  array[N] int<lower=0> hour; // hour hierarchy level
  
  int<lower=0> num_years;
  int<lower=0> num_days;
  int<lower=0> num_hours;
  
  array[N] int<lower=0> score; // post scores
}

parameters {
  vector<lower=0>[num_years] year_mu;
  vector<lower=0>[num_years] year_phi;
  vector<lower=0>[num_days] days_mu;
  vector<lower=0>[num_days] days_phi;
  vector<lower=0>[num_hours] hours_mu;
  vector<lower=0>[num_hours] hours_phi;
}

model {
  year_mu ~ normal(0, 100);
  year_phi ~ normal(0, 10);
  days_mu ~ normal(0, 50);
  days_phi ~ normal(0, 10);
  hours_mu ~ normal(0, 10);
  hours_phi ~ normal(0, 10);
  
  score ~ neg_binomial_2_log(
    year_mu[year] + days_mu[day] + hours_mu[hour], 
    year_phi[year] + days_phi[day] + hours_phi[hour]
  );
}