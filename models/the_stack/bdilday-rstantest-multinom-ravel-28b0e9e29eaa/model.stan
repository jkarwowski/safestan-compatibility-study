
data {
  int<lower=2> K;
  int<lower=1> N;
  int<lower=1> D;
  array[D] int<lower=0> LEVELS;
  int<lower=0> SUM_LEVELS;
  array[N] int<lower=1, upper=K> y;
  array[N, D] int<lower=1> x;
}

transformed data {

}

parameters {
  array[K, SUM_LEVELS] real ALPHAX;
  vector[K] C;
}

transformed parameters {

}

model {

  array[N] vector[K] lambda;

  for (k in 1:K) {
    C[k] ~ normal(0, 1);
    for (i in 1:SUM_LEVELS) {
      ALPHAX[k, i] ~ normal(0, 1);
    }
  }

  for (n in 1:N) {
    for (k in 1:K) {
      lambda[n][k] = C[k];
      for (d in 1:D) {
        lambda[n][k] = lambda[n][k] + ALPHAX[k,  x[n][d]  ];
    //    print(n, " ", d, " ", k, " ", x[n][d], " ", ALPHAX[k, x[n][d] ], " ", lambda[n][k]);
      }
    }
  }


  for (n in 1:N) {
    y[n] ~ categorical_logit(lambda[n]);
  }

}
