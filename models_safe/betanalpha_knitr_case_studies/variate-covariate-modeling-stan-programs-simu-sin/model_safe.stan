data {
  int<lower=1> N1;
  int<lower=1> N2;
}

transformed data {
  real A = 3;
  real phi = 4;
  real omega = 2;
  real sigma = 0.5;
}

generated quantities {
  array[N1] real x1;
  array[N1] real y1;

  array[N2] real x2;
  array[N2] real y2;

  for (n in 1:N1) {
    x1[n] = uniform_rng(0, 10);
    y1[n] = normal_rng(A * sin(omega * x1[n] + phi), sigma);
  }

  for (n in 1:N2) {
    x2[n] = abs(normal_rng(0, 3));
    y2[n] = normal_rng(A * sin(omega * x2[n] + phi), sigma);
  }
}
