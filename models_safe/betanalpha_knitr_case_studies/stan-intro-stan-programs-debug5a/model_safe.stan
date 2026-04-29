parameters {
  array[9] real x;
}

model {
  x ~ normal(0, 1.0 / 3.0);
}
