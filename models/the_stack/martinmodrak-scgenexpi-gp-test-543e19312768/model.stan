data {
  int num_cells;
  int<lower=2> num_time;

  array[num_cells] vector<lower=0>[2] expression;

  real<lower=0> bandwidth;
}

transformed data {
  array[num_time] real time;

  real num_steps_real = num_time - 1;
  for(i in 1:num_time) {
    time[i] = (i - 1) / num_steps_real;
  }
  print(time);
}

parameters {
  array[num_cells] vector[num_time] gp_raw;
  real<lower=0> gp_sigma;
  real<lower=0> expression_sigma;
}

transformed parameters {
  matrix[num_time, num_time] cov_m_chol = cholesky_decompose(gp_exp_quad_cov(time, gp_sigma, 1));
}

model {

  for(i in 1:num_cells) {
    vector[num_time] gp_value = log1p_exp(cov_m_chol * gp_raw[i]);
    expression[i, 1] ~ normal(gp_value[1],expression_sigma);
    expression[i, 2] ~ normal(gp_value[num_time],expression_sigma);
    gp_raw[i] ~ normal(0,1);
  }
  gp_sigma ~ cauchy(0, 5);
  expression_sigma ~ cauchy(0,5);
}

generated quantities {
  array[num_cells] vector<lower=0>[num_time] full_expression;
  for(i in 1:num_cells) {
    full_expression[i] = log1p_exp(cov_m_chol * gp_raw[i]);
  }

}
