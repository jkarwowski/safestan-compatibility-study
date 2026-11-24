// multinomial likelihood
// logistic normal prior
// uniform priors on mu, half-cauchy on cholesky 

data {
    int<lower=0> r;
    int<lower=0> c;
    array[r, c] int y;
    vector[c] alpha;
}
parameters {
    array[r] simplex[c] theta;
}
model {
    for (i in 1:r) {
        target += dirichlet_lpdf(theta[i] | alpha);
        target += multinomial_lpmf(y[i,] | theta[i]);
    } 
}
