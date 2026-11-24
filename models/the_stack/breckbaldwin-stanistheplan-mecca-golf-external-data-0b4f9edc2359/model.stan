data {
  int J;
  array[J] int x_distance;
  array[J] int y_successes;
  array[J] int n_attempts;
}

transformed data {
  real r = (1.68/2)/12;
  real R = (4.25/2)/12;
  array[J] real threshold_angle;
  print("J=",J);
  print("x_distance=",x_distance);
  print("y_successes=",y_successes);
  print("n_attemmpts=",n_attempts);

  for (i in 1:J) {
    threshold_angle[i] = asin((R-r)/x_distance[i]);
  }
}

parameters {
  real<lower=0> sigma_error_in_radians;
}

model {
  for (i in 1:J) {
    real prob = 2*Phi(threshold_angle[i]/sigma_error_in_radians) - 1;
    y_successes[i] ~ binomial(n_attempts[i], prob);
  }
}

generated quantities {
  real sigma_error_in_degrees = (180/pi())*sigma_error_in_radians;
  array[30] real chance_in_1_for_dist;
  real threshold_angle_for_distance;
  for (i in 1:30) { 
   threshold_angle_for_distance = asin((R-r)/i);
   chance_in_1_for_dist[i] = (2*Phi(threshold_angle_for_distance/ sigma_error_in_radians) - 1);
  }
}
