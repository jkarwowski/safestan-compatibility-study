// Endo: conditional inference in case-contrl studies 
// http://www.openbugs.net/Examples/Endo.html

// In this example, three methods of different 
// model specifications are used for one equivalent
// model. This is method 3. 

data {
  int n10;
  int n01;
  int n11;
  int I;
  array[I] int<lower=0> Y1;
  array[I] int<lower=0> Y2;
}
transformed data {
  array[2] vector<lower=0>[I] est;
  for (i in 1 : n10) {
    est[1, i] = 1;
    est[2, i] = 0;
  }
  for (i in (n10 + 1) : (n10 + n01)) {
    est[1, i] = 0;
    est[2, i] = 1;
  }
  for (i in (n10 + n01 + 1) : (n10 + n01 + n11)) {
    est[1, i] = 1;
    est[2, i] = 1;
  }
  for (i in (n10 + n01 + n11 + 1) : I) {
    est[1, i] = 0;
    est[2, i] = 0;
  }
}
parameters {
  real beta;
  vector[I] beta0;
}
model {
  // METHOD 3 fit standard Poisson regressions relative to baseline
  beta ~ normal(0, 1000);
  beta0 ~ normal(0, 1000);
  Y1 ~ poisson_log(beta0 + beta * est[1]);
  Y2 ~ poisson_log(beta0 + beta * est[2]);
}
