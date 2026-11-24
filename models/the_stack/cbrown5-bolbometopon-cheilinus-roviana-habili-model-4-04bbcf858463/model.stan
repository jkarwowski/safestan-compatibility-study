data{
    int<lower=1> N;
    int<lower=1> N_site;
    array[N] int abund;
    array[N] int jsite;
    array[N] real xyear;
}
parameters{
    real a;
    real b_n;
    vector[N_site] aj;
    real<lower=0> sigma_aj;
}
model{
  vector[N] mu;

  // UVC model 
    sigma_aj ~ exponential( 1 );
    aj ~ normal( 0 , sigma_aj );
    b_n ~ normal(0 , 10);
    a ~ normal( 0 , 5);
    for ( i in 1:N ) {
        mu[i] = a + aj[jsite[i]] + b_n * xyear[i];
        mu[i] = exp(mu[i]);
    }
    abund ~ poisson( mu );
}

