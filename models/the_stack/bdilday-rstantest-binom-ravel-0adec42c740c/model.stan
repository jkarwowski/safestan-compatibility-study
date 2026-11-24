
data {
  int<lower=0> N;
  int<lower=1> D;
  array[D] int<lower=0> LEVELS;
  int<lower=0> SUM_LEVELS;
  int<lower=0> MAX_LEVEL;
  array[N] int<lower=0, upper=1> y;
  array[N, D] int<lower=0, upper=MAX_LEVEL> x;
}

transformed data {
  array[2, D] int CU_LEVELS;
  CU_LEVELS[1, 1] = 1;
  CU_LEVELS[2, 1] = LEVELS[1];
  for (d in 2:D) {
    CU_LEVELS[1, d] = CU_LEVELS[1, d-1] + LEVELS[d-1];
    CU_LEVELS[2, d] = CU_LEVELS[2, d-1] + LEVELS[d-1];
  }
}

parameters {
  array[SUM_LEVELS] real ALPHAX;
//  real alpha[MAX_LEVEL, D];
  real C;
}

transformed parameters {

}

model {
  array[N] real lambda;

  for (i in 1:SUM_LEVELS) {
  ALPHAX[i] ~ normal(0, 1);
  }

  for (n in 1:N) {
    lambda[n] = C;
    for (d in 1:D) {
      lambda[n] = lambda[n] + ALPHAX[ x[n][d]  ];
    }
  }

  y ~ bernoulli_logit(lambda);

}
