data {
  int<lower=1> N;
  array[N + 1] real t;

  real x0;

  real mu;
  real<lower=0> gamma;
  real<lower=0> tau;
}

parameters {
  array[N] real x_free;
}

transformed parameters {
  array[N + 1] real x = append_array(rep_array(x0, 1), x_free);
}

model {
  for (n in 1:N) {
    real epsilon = t[n + 1] - t[n];
    x[n + 1] ~ normal(x[n] + gamma * (mu - x[n]) * epsilon, tau * sqrt(epsilon) );
  }
}
