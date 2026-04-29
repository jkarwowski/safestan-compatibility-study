/*
 * Endo: conditional inference in case-contrl studies 
 * http://www.openbugs.net/Examples/Endo.html
 *
 * In this example, three methods of different 
 * model specifications are used for one equivalent
 * model. This is method 2. 

 * FIXME: using the multinomial specification  
 */
data {
  int n10;
  int n01;
  int n11;
  int I;
  int J;
  array[I] int<lower=0, upper=1> Y_safestan;
}
transformed data {
  array[I, 2] int<lower=0> est;
  for (i in 1 : I) {
    if (i <= n10) {
      est[i, 1] = 1;
      est[i, 2] = 0;
    } else if (i <= n10 + n01) {
      est[i, 1] = 0;
      est[i, 2] = 1;
    } else if (i <= n10 + n01 + n11) {
      est[i, 1] = 1;
      est[i, 2] = 1;
    } else {
      est[i, 1] = 0;
      est[i, 2] = 0;
    }
  }
}
parameters {
  real beta;
}
model {
  vector[I] eta;
  
  // METHOD 2 - conditional likelihoods
  beta ~ normal(0, 1000);
  
  for (i in 1 : I) {
    eta[i] = beta * (est[i, 1] - est[i, 2]);
  }
  Y_safestan ~ bernoulli_logit(eta);
}
