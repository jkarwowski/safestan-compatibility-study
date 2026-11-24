
data {
  int K;
  int N;
  int D;
  array[N] int y;
  array[N] vector[D] x;
}

transformed data {

}

parameters {
  matrix[K, D] ALPHAX;
}

transformed parameters {

}

model {

  for (k in 1:K) {
    for (d in 1:D) {
      ALPHAX[k, d] ~ normal(0.0, 1.0);
    }
  }

  for (n in 1:N) {
    y[n] ~ categorical_logit( ALPHAX * x[n] );
  }


}
