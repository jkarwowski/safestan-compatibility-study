// .stan for McElreath_Example_Multithreading.Rmd

 data {
  int N;
  array[N] int n_redcards;
  array[N] int n_games;
  array[N] real rating;
}

parameters {
  vector[2] beta;
}

model{
  beta ~ normal(0,1);
  n_redcards ~ binomial_logit( n_games, beta[1] + beta[2] * to_vector(rating) );
}
