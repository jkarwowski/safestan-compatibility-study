
data {
  int<lower=2> K; // classes
  int<lower=0> N; // data points
  int<lower=1> D; // number of predictors / random effects
  array[K, D] real<lower=0> RANEF_SIGMA; // sd of random effects
  array[D] int<lower=0> LEVELS; // number of levels of each predictor
  int<lower=0> SUM_LEVELS;
  int<lower=0> MAX_LEVEL;
  array[N] int<lower=1, upper=K> y;
  array[N, D] int<lower=1, upper=MAX_LEVEL> x;
}

transformed data {
  array[2, D] int CU_LEVELS;
  CU_LEVELS[1, 1] = 1;
  CU_LEVELS[2, 1] = LEVELS[1];
  for (d in 2:D) {
    CU_LEVELS[1, d] = CU_LEVELS[1, d-1] + LEVELS[d-1];
    CU_LEVELS[2, d] = CU_LEVELS[2, d-1] + LEVELS[d];
  }

  print("RANEF_SIGMA", RANEF_SIGMA);
  print("RANEF_SIGMA k=1 d=3 ", RANEF_SIGMA[1, 3]);
  print("RANEF_SIGMA k=3 d=1 ", RANEF_SIGMA[3, 1]);

}

parameters {
  array[K, SUM_LEVELS] real ALPHAX;
  //
//  real alpha[MAX_LEVEL, D];
  array[K] real CX;
}

transformed parameters {


}

model {
  array[N] vector[K] lambda;

  for (k in 1:K) {
    CX[k] ~ normal(0, 10);
  }

  for (i in 1:SUM_LEVELS) {
    for (k in 1:K) {
      for (d in 1:D) {
        if (i >= CU_LEVELS[1,d] && i <= CU_LEVELS[2,d]) {
//            print("alpha norm ", i, k, d, RANEF_SIGMA[k, d]);
            ALPHAX[k, i] ~ normal(0, RANEF_SIGMA[k, d]);
          }
      }
    }
  }

  for (n in 1:N) {
    for (k in 1:K) {
      lambda[n][k] = CX[k];
      for (d in 1:D) {
        lambda[n][k] = lambda[n][k] + ALPHAX[k, x[n][d]  ];
      // print("lambda "
      // , n, " "
      // , k, " "
      // , d, " "
      // , lambda[n][k], " "
      // )
      }
    }
    }

 for (n in 1:N) {
//   print("lambda[n] ", n, " ", lambda[n]);
  y[n] ~ categorical_logit(lambda[n]);
 }

}
