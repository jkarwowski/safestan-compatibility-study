
data {
int<lower=0> n;
array[n] int<lower=0, upper=1> y;
int j;
array[j] int pol;
array[n] int who;
array[n] real confidence;
array[n] real socConfidence;
}

parameters {

array[5] real alpha_p;
array[5] real b_conf_p;
array[5] real b_socConf_p;

array[j] real alpha;
array[j] real b_conf;
array[j] real b_socConf;

}

model {
array[n] real theta;

for (pi in 1:5){
alpha_p[pi] ~ normal(0,2);
b_conf_p[pi] ~ normal(0,2);
b_socConf_p[pi] ~ normal(0,2);

}


for (idx in 1:j){

alpha[idx] ~ normal(alpha_p[pol[idx]],1);
b_conf[idx] ~ normal(b_conf_p[pol[idx]],1);
b_socConf[idx]~ normal(b_socConf_p[pol[idx]],1);

}

for (i in 1:n){
theta[i] = alpha[who[i]] + b_conf[who[i]] * confidence[i] +
                        b_socConf[who[i]]*socConfidence[i];

}

y ~ bernoulli_logit(theta);

}


generated quantities {
array[n] int yhat;
array[n] real theta_hat;

for (i in 1:n){
    theta_hat[i] = alpha[who[i]] + b_conf[who[i]] * confidence[i] +
                            b_socConf[who[i]]*socConfidence[i];
    yhat[i] = bernoulli_logit_rng(theta_hat[i]);
}


}
