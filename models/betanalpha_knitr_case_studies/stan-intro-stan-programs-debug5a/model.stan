parameters {
  array[9] real x;
}

model {
  for (n in 1:9)
    x ~ normal(0, 1);
}
