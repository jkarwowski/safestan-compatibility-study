
    data{
        int N; // number of observations
        int K; // number of response categories
        int J; // number of groups
        int D; // number of predictors
        array[N] int<lower=1, upper=K> y;  // the outcome
        array[N] row_vector[D] x; // predictors
        array[N] int group;  // map observations to groups
    }
    parameters{
        ordered[K-1] kappa; // cut points
        vector[D] beta; //coefficients
        array[J] real zeta;
        real<lower=0,upper=10> sigma;
    }
    model{
        for(i in 1:N){
            y[i] ~ ordered_logistic(x[i]*beta + zeta[group[i]], kappa);
        }
        target += normal_lpdf(zeta|0, sigma);
        target += normal_lpdf(kappa|0,10);
        target += uniform_lpdf(sigma|0,10);
    }

