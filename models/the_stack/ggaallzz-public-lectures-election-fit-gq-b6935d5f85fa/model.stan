data {
  int K; // number of categories
  array[K] int y; //result of survey
}

parameters {
  simplex[K] theta;
}

model {
  y ~ multinomial(theta);
}
generated quantities {
  array[K] int y_sim;
  real advantage = theta[1]-theta[2];
  {
    int n;
    n = sum(y);
    y_sim = multinomial_rng(theta,n);
  }
}
