data {
  int N;
  array[N] real Weight;
  array[N] real Age;
  array[N] real Y;
}

parameters {
  array[2] real c;
  array[3] real b;
  real<lower=0> s_W;
  real<lower=0> s_Y;
}

transformed parameters {
  array[N] real mu_W;
  array[N] real mu_Y;
  for (n in 1:N){
    mu_W[n] = c[1] + c[2]*Age[n];
    mu_Y[n] = b[1] + b[2]*Age[n] + b[3]*Weight[n];
  }
}

model {
  for (n in 1:N) {
    Weight[n] ~ normal(mu_W[n], s_W);
    Y[n] ~ normal(mu_Y[n], s_Y);
  }
}
