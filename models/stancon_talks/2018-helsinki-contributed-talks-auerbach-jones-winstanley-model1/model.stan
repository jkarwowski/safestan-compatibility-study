data {
  int<lower=1> N;                   // number of observations
  int<lower=1> T;                   // number of tracts
  int<lower=1> G;                   // number of grades
  int<lower=1> Y;                   // number of years
  int<lower=1> C;                   // number of cohorts
  array[N] int num_students;              // response var
  array[N] int<lower=1,upper=T> tract;    // tract id's
  array[N] int<lower=1,upper=G> grade;    // grade id's
  array[N] int<lower=1,upper=Y> year;     // year id's
  array[N] int<lower=1,upper=C> cohort;   // cohort id's
}

parameters {
  array[T] real mu;
  array[G, T] real alpha_grade;
  array[Y, T] real alpha_year;
  array[C, T] real alpha_cohort;
  array[Y] real<lower=0> tau_year;
  array[G] real<lower=0> tau_grade;
  array[C] real<lower=0> tau_cohort;
  real<lower=0> sigma;
}

transformed parameters {
  array[N] real theta;
  for(n in 1:N)
    theta[n] = sigma * mu[tract[n]] +
               tau_year[  year[n]]   * alpha_year[  year[n],   tract[n]] +
               tau_grade[ grade[n]]  * alpha_grade[ grade[n],  tract[n]] +
               tau_cohort[cohort[n]] * alpha_cohort[cohort[n], tract[n]];
}

model {
    mu ~ normal(0, 1);

    for(g in 1:G) alpha_grade[g,]  ~  normal(0, 1);
    for(y in 1:Y) alpha_year[y,]   ~  normal(0, 1);
    for(c in 1:C) alpha_cohort[c,] ~  normal(0, 1);

    num_students ~ poisson_log(theta);

}
