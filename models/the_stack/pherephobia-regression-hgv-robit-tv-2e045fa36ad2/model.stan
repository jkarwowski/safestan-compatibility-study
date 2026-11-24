data {
  int N;
  real df;
  vector [N] x;
  array[N] int y;
}
parameters {
  real a;
  real b;
}
model {
  vector[N] p;
  for (n in 1:N) {
    p[n] = student_t_cdf(a + b * x[n] | df, 0, sqrt((df - 2) / df));
  } 
  y ~ bernoulli(p);
}
