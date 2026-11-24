data {
  int N;
  vector[N] weight;
  array[N] real heights;
}

parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] mu = weight*beta+alpha;
}

model {
  alpha ~ normal(178,20);
  beta ~ lognormal(0,1);
  sigma ~ exponential(0.067);
  heights ~ normal(mu,sigma);
}

generated quantities {
  array[N] real height;
  for (i in 1:N) {
    height[i] = normal_rng(mu[i],sigma);
  }
}
