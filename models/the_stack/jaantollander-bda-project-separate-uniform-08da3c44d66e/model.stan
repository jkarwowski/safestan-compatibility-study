data {
  int<lower=0> N; // number of data points
  int<lower=0> K; // number of groups
  array[N] int<lower=1,upper=K> x; // group indicator
  vector[N] sales; // sales
  vector[N] scores; // critic scores
}
parameters {
  vector[K] mu_sales;
  vector[K] mu_scores;
  array[K] real<lower=0> sigma_sales;
  array[K] real<lower=0> sigma_scores;
}
model {
  sales ~ normal(mu_sales[x], sigma_sales[x]);
  scores ~ normal(mu_scores[x], sigma_scores[x]);
}
generated quantities {
  vector[N] sales_log_lik;
  vector[N] scores_log_lik;
  for (i in 1:N) {
    sales_log_lik[i] = normal_lpdf(sales[i] | mu_sales[x[i]], sigma_sales[x[i]]);
  }
  for (i in 1:N) {
    scores_log_lik[i] = normal_lpdf(scores[i] | mu_scores[x[i]], sigma_scores[x[i]]);
  }
}
