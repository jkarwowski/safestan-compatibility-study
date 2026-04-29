data {
   // Number of observations
  int<lower=0> N;

  // Main factor indices
  int<lower=0> N_main_factors;
  array[N_main_factors] int<lower=0> N_main_factor_levels;
  array[N_main_factors, N] int<lower=1> main_factor_level_idx;
}

transformed data {
  int N1 = choose(N_main_factors, 2);
  int N2 = choose(N_main_factors, 3);
}

generated quantities {
  // First-order interaction indices
  int N_inter1_factors = N1;          // Number of interaction factors
  array[N1] int N_inter1_factor_levels;     // Number of levels within each interaction factor
  array[N1] int inter1_factor1_idx;         // First main factor in interaction
  array[N1] int inter1_factor2_idx;         // Second main factor in interaction
  array[N1, N] int inter1_factor_level_idx; // Interaction level assignments for each observation

  // Second-order interaction indices
  int N_inter2_factors = N2;          // Number of interaction factors
  array[N2] int N_inter2_factor_levels;     // Number of levels within each interaction factor
  array[N2] int inter2_factor1_idx;         // First main factor in interaction
  array[N2] int inter2_factor2_idx;         // Second main factor in interaction
  array[N2] int inter2_factor3_idx;         // Third main factor in interaction
  array[N2, N] int inter2_factor_level_idx; // Interaction level assignments for each observation

  // Construct first-order interactions
  for (i in 1:N_main_factors) {
    // Number of first-order interactions with first index less than i
    int N_i = (i - 1) * N_main_factors - (i - 1) * i / 2;

    for (j in (i + 1):N_main_factors) {
      int idx = N_i + j - i;
      N_inter1_factor_levels[idx] = N_main_factor_levels[i] * N_main_factor_levels[j];
      inter1_factor1_idx[idx] = i;
      inter1_factor2_idx[idx] = j;
    }
  }

  // Construct second-order interactions
  for (i in 1:N_main_factors) {
    // Number of second-order interactions with first index less than i
    int N_i =   (i - 1) * N_main_factors * (N_main_factors - 1) / 2
              - N_main_factors * (i - 1) * i / 2
              + (i - 1) * i * (i + 1) / 6;

    for (j in (i + 1):N_main_factors) {
      // Number of second-order interactions with first index equal to i
      // and second index less than j
      int N_j =   (j - 1) * N_main_factors - (j - 1) * j / 2
                - (N_main_factors * i - i * (i + 1) / 2);

      for (k in (j + 1):N_main_factors) {
        int idx = N_i + N_j + (k - j);
        N_inter2_factor_levels[idx] =   N_main_factor_levels[i]
                                      * N_main_factor_levels[j]
                                      * N_main_factor_levels[k];
        inter2_factor1_idx[idx] = i;
        inter2_factor2_idx[idx] = j;
        inter2_factor3_idx[idx] = k;
      }
    }
  }

  for (n in 1:N) {
    // Assign first-order interactions
    for (i in 1:N_main_factors) {
      int N_i = (i - 1) * N_main_factors - (i - 1) * i / 2;

      for (j in (i + 1):N_main_factors) {
        int idx = N_i + j - i;
        inter1_factor_level_idx[idx, n]
          =   (main_factor_level_idx[i, n] - 1) * N_main_factor_levels[j]
            +  main_factor_level_idx[j, n];
      }
    }

    // Assign second-order interactions
    for (i in 1:N_main_factors) {
      int N_i =   (i - 1) * N_main_factors * (N_main_factors - 1) / 2
                - N_main_factors * (i - 1) * i / 2
                + (i - 1) * i * (i + 1) / 6;

      for (j in (i + 1):N_main_factors) {
        int N_j =   (j - 1) * N_main_factors - (j - 1) * j / 2
                  - (N_main_factors * i - i * (i + 1) / 2);

        for (k in (j + 1):N_main_factors) {
          int idx = N_i + N_j + (k - j);
          inter2_factor_level_idx[idx, n]
            =   (main_factor_level_idx[i, n] - 1) * N_main_factor_levels[j] * N_main_factor_levels[k]
              + (main_factor_level_idx[j, n] - 1) * N_main_factor_levels[k]
              +  main_factor_level_idx[k, n];
        }
      }
    }
  }
}
