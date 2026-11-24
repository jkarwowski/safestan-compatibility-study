
data {
  int n;
  array[n] real x;
  int j;
  array[n] int who;
  array[j] int pol;
  int NStates;
  array[n] int state;
  array[n] int<lower=0, upper=1> correct;
}

parameters {
  array[j] real alpha;
  array[j] real beta;
  array[j] real accuracy;
  array[5] real alpha_p;
  array[5] real beta_p;
  array[5] real accuracy_p;
  vector[NStates-1] beta_state_raw;
}

transformed parameters {
  vector[NStates] beta_state = append_row(beta_state_raw, -sum(beta_state_raw));
}


model {
  array[n] real theta;
  array[n] real mu;

  for (p in 1:5){
    alpha_p[p] ~ normal(0,.4);
    beta_p[p] ~ normal(0,.4);
    accuracy_p[p] ~ normal(0,.4);
  }

  beta_state ~ normal(0,.4);



  for(jj in 1:j){
    alpha[jj] ~ normal(alpha_p[pol[jj]], .4);
    beta[jj] ~ normal(beta_p[pol[jj]], .4);
    accuracy[jj] ~ normal(accuracy_p[pol[jj]], .4);
  }

  for (i in 1:n) {
    theta[i] = alpha[who[i]] + beta[who[i]]*x[i] + beta_state[state[i]];
    mu[i] = accuracy[who[i]];
  }
  correct ~ bernoulli_logit(mu);
  correct ~ bernoulli_logit(theta);
}
