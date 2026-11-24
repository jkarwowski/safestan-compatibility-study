data {
    int<lower=1> N;
    array[N] int<lower=0> n;
    array[N] int<lower=0> x;
}
parameters {
    real<lower=0> kappa;
    real<lower=0,upper=1> phi;
    vector<lower=0,upper=1>[N] theta;
}
model {
    kappa ~ cauchy(0, 2);
    theta ~ beta(phi*kappa, (1-phi)*kappa);
    x ~ binomial(n, theta);
}
