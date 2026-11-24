data{
    int N; // number of observations
    int K; // number of response categories
    int D; // number of predictors
    array[N] int<lower=1, upper=K> y;  // the outcome
    matrix[D,N] x; // predictors
}
parameters{
    matrix[K,D] beta;
}
transformed parameters{
    matrix[K,N] xbeta;
    
    xbeta = beta * x;
}
model{
 
    target += normal_lpdf(to_vector(beta)|0,10);
    
    for(i in 1:N){
        y[i] ~ categorical_logit(xbeta[,i]);
    }
}
