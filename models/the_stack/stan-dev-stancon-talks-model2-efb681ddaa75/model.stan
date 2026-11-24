data {
  int<lower=1> N;                   // number of observations
  int<lower=1> T;                   // number of tracts
  int<lower=1> Z;                   // number of zones
  int<lower=1> H;                   // number of neighorhoods
  int<lower=1> L;                   // number of land
  int<lower=1> G;                   // number of grades
  int<lower=1> Y;                   // number of years
  int<lower=1> C;                   // number of cohorts
  array[N] int num_students;              // response var
  array[N] int<lower=1,upper=T> tract;    // tract id's
  array[T] int<lower=1,upper=Z> zone;     // zone id's
  array[T] int<lower=1,upper=H> nbhd;     // neighborhood id's
  array[T] int<lower=1,upper=L> land;     // land id's
  array[N] int<lower=1,upper=G> grade;    // grade id's
  array[N] int<lower=1,upper=Y> year;     // year id's
  array[N] int<lower=1,upper=C> cohort;   // cohort id's
}

parameters {
  array[T] real mu;
  real<lower=0> sigma;
  array[G] real<lower=0> tau_grade_zone;
  array[G] real<lower=0> tau_grade_nbhd;
  array[G] real<lower=0> tau_grade_land;
  array[Y] real<lower=0> tau_year_zone;
  array[Y] real<lower=0> tau_year_nbhd;
  array[Y] real<lower=0> tau_year_land;
  array[C] real<lower=0> tau_cohort_zone;
  array[C] real<lower=0> tau_cohort_nbhd;
  array[C] real<lower=0> tau_cohort_land;
  array[G, Z] real beta_grade_zone;
  array[G, H] real beta_grade_nbhd;
  array[G, L] real beta_grade_land;
  array[Y, Z] real beta_year_zone;
  array[Y, H] real beta_year_nbhd;
  array[Y, L] real beta_year_land;  
  array[C, Z] real beta_cohort_zone;
  array[C, H] real beta_cohort_nbhd;
  array[C, L] real beta_cohort_land;
}

transformed parameters {
  array[N] real theta;
  for(n in 1:N)
    theta[n] = sigma             * mu[tract[n]]                                + 
      tau_grade_zone[grade[n]]   * beta_grade_zone[grade[n],   zone[tract[n]]] +
      tau_grade_nbhd[grade[n]]   * beta_grade_nbhd[grade[n],   nbhd[tract[n]]] +
      tau_grade_land[grade[n]]   * beta_grade_land[grade[n],   land[tract[n]]] + 
      tau_year_zone[year[n]]     * beta_year_zone[year[n],     zone[tract[n]]] +
      tau_year_nbhd[year[n]]     * beta_year_nbhd[year[n],     nbhd[tract[n]]] +
      tau_year_land[year[n]]     * beta_year_land[year[n],     land[tract[n]]] +
      tau_cohort_zone[cohort[n]] * beta_cohort_zone[cohort[n], zone[tract[n]]] +
      tau_cohort_nbhd[cohort[n]] * beta_cohort_nbhd[cohort[n], nbhd[tract[n]]] +
      tau_cohort_land[cohort[n]] * beta_cohort_land[cohort[n], land[tract[n]]];
}

model {

 mu ~ normal(0, 1);

  for(g in 1:G) {
    beta_grade_zone[g, ]  ~ normal(0, 1);
    beta_grade_nbhd[g, ]  ~ normal(0, 1);
    beta_grade_land[g, ]  ~ normal(0, 1);
  }
  
  for(y in 1:Y) {
    beta_year_zone[y, ]   ~ normal(0, 1);
    beta_year_nbhd[y, ]   ~ normal(0, 1);
    beta_year_land[y, ]   ~ normal(0, 1);
  }
  
  for(c in 1:C) {
    beta_cohort_zone[c, ] ~ normal(0, 1);
    beta_cohort_nbhd[c, ] ~ normal(0, 1);
    beta_cohort_land[c, ] ~ normal(0, 1);
  }
  
tau_grade_zone          ~ gamma(2, 1/G);
tau_grade_nbhd          ~ gamma(2, 1/G);
tau_grade_land          ~ gamma(2, 1/G);
tau_year_zone           ~ gamma(2, 1/Y);
tau_year_nbhd           ~ gamma(2, 1/Y);
tau_year_land           ~ gamma(2, 1/Y);
tau_cohort_zone         ~ gamma(2, 1/Z);
tau_cohort_nbhd         ~ gamma(2, 1/Z);
tau_cohort_land         ~ gamma(2, 1/Z);
  
  num_students            ~ poisson_log(theta);
}
  