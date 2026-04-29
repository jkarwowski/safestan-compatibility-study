// Endo: conditional inference in case-contrl studies 
// http://www.openbugs.net/Examples/Endo.html

// In this example, three methods of different 
// model specifications are used for one equivalent
// model. This is method 1. 

data {
  int n10;
  int n01;
  int n11;
  int I;
  array[I] int<lower=0, upper=1> Y1_safestan;
}
transformed data {
  vector[I] est1m2;
  for (i in 1 : I) {
    if (i <= n10) {
      est1m2[i] = 1;
    } else if (i <= n10 + n01) {
      est1m2[i] = -1;
    } else {
      est1m2[i] = 0;
    }
  }
}
parameters {
  real beta;
}
model {
  // METHOD 1: Logistic regression 
  beta ~ normal(0, 1000);
  Y1_safestan ~ binomial_logit(1, beta * est1m2);
}
