data {
    int players;
    array[players] int player;
    array[players] int shots;
    array[players] int saves;
    real alpha;
    real beta;
}
parameters {
    array[players] real<lower=0, upper=1> theta;
}
model {
    theta ~ beta(alpha, beta);
    saves ~ binomial(shots, theta);
}
