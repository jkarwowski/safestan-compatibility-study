data { 
  int<lower=0> al_n;
  array[al_n] real allo;
  int<lower=0> al_n_c;
  array[al_n_c] real allo_c;
  int<lower=0> au_n;
  array[au_n] real aut;
  int<lower=0> au_n_c;
  array[au_n_c] real aut_c;
} 
parameters {
  real<lower=0> theta_l;
  real<lower=0> theta_u;
} 
model {
  
  for (n in 1:al_n) 
    target += log(theta_l * exp(-theta_l * allo[n]));
  
  for (n in 1:al_n_c) 
    target += (-theta_l * allo_c[n]);
    
  for (n in 1:au_n)
    target += log(theta_u * exp(-theta_u * aut[n]));
  
  for (n in 1:au_n_c) 
    target += (-theta_u * aut_c[n]);
}
