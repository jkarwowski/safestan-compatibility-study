# SafeStan Safety Note

Compatibility: minor.

Protected data: `W_z1`, `Y_z1_w1`, `Y_z1_w0`, `Y_z0_w0`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target +=` likelihood with built-in, vectorized Bernoulli sampling statements over deterministic top-level reshapes of the observed data. The generated data fields are defined as `W_z1 = W[n]` for rows with `Z[n] == 1`; `Y_z1_w1 = Y[n]` for rows with `Z[n] == 1 && W[n] == 1`; `Y_z1_w0 = Y[n]` for rows with `Z[n] == 1 && W[n] == 0`; and `Y_z0_w0 = Y[n]` for rows with `Z[n] == 0 && W[n] == 0`, with matching `N_*` lengths. Rows with `Z[n] == 0 && W[n] == 1` are not copied because the original program added no likelihood term for them. The `log_mix` Bernoulli mixture for `Z == 0, W == 0` was rewritten exactly as a Bernoulli likelihood with probability `pi_c * eta_c0 + (1 - pi_c) * eta_n0`. Added the explicit density-neutral prior `pi_c ~ uniform(0, 1)` for the bounded parameter that previously had an implicit uniform prior.
