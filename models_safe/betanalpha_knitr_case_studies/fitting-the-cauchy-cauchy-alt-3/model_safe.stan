parameters {
  vector<lower=0, upper=1>[50] x_tilde;
}

transformed parameters {
  vector[50] x = tan(pi() * (x_tilde - 0.5));
}

model {
  x_tilde ~ uniform(0, 1);
}

generated quantities {
  real I = abs(x[1]) < 1 ? 1 : 0;
}
