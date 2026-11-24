data {
int N;
array[N] int cond;
array[N] int y;
array[N] int count;
}
parameters{
array[6] real alpha;
}


model {
array[N] real mu;

alpha ~ normal(0,.2);

for(n in 1:N){
mu[n] = inv_logit(alpha[cond[n]]);
y[n] ~ binomial(count[n],mu[n]);
}


}
