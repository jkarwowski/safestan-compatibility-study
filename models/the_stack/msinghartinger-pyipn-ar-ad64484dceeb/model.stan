data {
  int<lower=0> N;
  array[N] int y;
}
parameters {
  real alpha;
  real beta;

}
model {
  for (n in 2:N)
    y[n] ~ poisson(alpha + beta * y[n-1]);
}

generated quantities {

  array[N] int out;


  out[1] = poisson_rng(y[1]); 
  
  for (n in 2:N) {


    out[n] = poisson_rng(alpha + beta * y[n-1]);

  }


}
