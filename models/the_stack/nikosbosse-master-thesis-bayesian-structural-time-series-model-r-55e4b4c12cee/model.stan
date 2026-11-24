data {
  int t;
  array[t] real past_r;
  int n_pred;
}

transformed data{
  array[t] real r;
  for (i in 1:t){
    r[i] = log(past_r[i] / (15 - past_r[i]));
  }
}


parameters{
  real <lower = 0> sigma_epsilon;
  real <lower = 0> sigma_eta;
  real <lower = -1, upper = 1> phi;
  array[t] real delta;
  real D;

}

/*transformed parameters{
}
*/
model {
  for (s in 1:(t-1)){
    // vectorize
    // see https://mc-stan.org/docs/2_20/stan-users-guide/autoregressive-section.html
    past_r[s+1] ~ normal(past_r[s] + delta[s], sigma_epsilon);
    delta[s+1] ~ normal(D + phi * (delta[s] - D), sigma_eta);
  }
  delta[1] ~ normal(D, sigma_eta);
  D ~ normal(0,1);
  phi ~ normal(0, 0.1);
  sigma_eta ~ inv_gamma(1, 1); // random values I chose
  sigma_epsilon ~ inv_gamma(1, 1); // random values I chose
}



generated quantities{
  array[n_pred] real r_pred;
  array[n_pred] real delta_pred;


  r_pred[1] = normal_rng(past_r[t] + delta[t], sigma_epsilon);
  delta_pred[1] = normal_rng(D + phi * (delta[t] - D), sigma_epsilon);

  for (s in 1:(n_pred - 1)){
    r_pred[s + 1] = normal_rng(r_pred[s] + delta_pred[s], sigma_epsilon);
    delta_pred[s + 1] = normal_rng(D + phi * (delta_pred[s] - D), sigma_epsilon);
  }
}


