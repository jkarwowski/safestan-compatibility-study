data {
  int<lower=0> N;
  int<lower=0> N_edges;
  array[N_edges] int<lower=1, upper=N> node1; // node1[i] adjacent to node2[i]
  array[N_edges] int<lower=1, upper=N> node2; // and node1[i] < node2[i]
}
transformed data {
  matrix[N, N] Q = rep_matrix(0, N, N);
  vector[N] phi_zero = rep_vector(0, N);
  real sum_to_zero_precision = 1 / square(0.01 * N);

  for (e in 1:N_edges) {
    Q[node1[e], node1[e]] += 1;
    Q[node2[e], node2[e]] += 1;
    Q[node1[e], node2[e]] -= 1;
    Q[node2[e], node1[e]] -= 1;
  }

  Q += rep_matrix(sum_to_zero_precision, N, N);
}
parameters {
  vector[N] phi;
}
model {
  phi ~ multi_normal_prec(phi_zero, Q);
}
