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
  array[t] real<lower = 0> sigma_epsilon;
  array[t] real<lower = 0> sigma_eta;
  array[t] real<lower = -1, upper = 1> phi;
  array[t] real delta;
  array[t] real D;

}

/*transformed parameters{
}
*/
model {
  for (i in 1:t){
    
    for (s in 1:(i-1)){
    // vectorize
    // see https://mc-stan.org/docs/2_20/stan-users-guide/autoregressive-section.html
    past_r[s+1] ~ normal(past_r[s] + delta[s], sigma_epsilon[i]);
    delta[s+1] ~ normal(D[i] + phi[i] * (delta[s] - D[i]), sigma_eta[i]);
    }

    delta[1] ~ normal(D[i], sigma_eta[i]);
    D[i] ~ normal(0,1);
    phi[i] ~ normal(0, 0.1);
    sigma_eta[i] ~ inv_gamma(1, 1); // random values I chose
    sigma_epsilon[i] ~ inv_gamma(1, 1); // random values I chose

  }

}



generated quantities{
  array[n_pred + t] real r_pred;
  array[n_pred] real delta_pred;

/*  r_pred[1] = normal_rng(past_r[t] + delta[t], sigma_epsilon);*/

  r_pred[1] = 0;

  delta_pred[1] = normal_rng(D[t] + phi[t] * (delta[t] - D[t]), sigma_epsilon[t]);

  // predictions based on actual data
  for (i in 1:t){
    r_pred[i + 1] = normal_rng(past_r[i] + delta[i], sigma_epsilon[i]);    
  }

  // predictions where no values are observed
  for (i in 2:(n_pred)){
    r_pred[t + i] = normal_rng(r_pred[t + i - 1] + delta_pred[i-1], sigma_epsilon[t]);
    delta_pred[i] = normal_rng(D[t] + phi[t] * (delta_pred[i-1] - D[t]), sigma_epsilon[t]);    
  }


/*
  delta_pred[1] = normal_rng(D[t] + phi[t] * (delta[t] - D[t]), sigma_epsilon[t]);

  for (s in 1:(n_pred - 1)){
    r_pred[s + 1] = normal_rng(r_pred[s] + delta_pred[s], sigma_epsilon[t]);
    delta_pred[s + 1] = normal_rng(D[t] + phi[t] * (delta_pred[s] - D[t]), sigma_epsilon[t]);
  }*/
}


