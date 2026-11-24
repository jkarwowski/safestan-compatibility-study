data {
   int N; //no. of samples
   array[N] int resets; //no. of resets in observed period
   array[N] real failure_time; //no. of failures in observed period
}

parameters {
   real<lower=0> reset_const;
   real<lower=0> shape;
   real<lower=0> failure_const;
   real<lower=0> type_coef;
}

model {
   type_coef ~ normal(0,10);
         resets ~ poisson(reset_const*type_coef);
      failure_time ~ gamma(shape, failure_const*type_coef);
   
}