# SafeStan Safety Note

Compatibility: minor.

Protected data: `W_z1`, `Y_z1_w1`, `Y_z1_w0`, and `Y_z0_w0`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the disallowed manual `target +=` likelihood with vectorized built-in Bernoulli sampling statements over deterministic top-level partitions of the originally scored data. `W_z1` is `W[n]` for rows with `Z[n] == 1`; `Y_z1_w1` is `Y[n]` for rows with `Z[n] == 1 && W[n] == 1`; `Y_z1_w0` is `Y[n]` for rows with `Z[n] == 1 && W[n] == 0`; and `Y_z0_w0` is `Y[n]` for rows with `Z[n] == 0 && W[n] == 0`, all in original row order. The count variables are the corresponding lengths. For the `Z == 0, W == 0` branch, the Bernoulli mixture was collapsed using the identity `log_mix(pi_c, bernoulli_lpmf(y | eta_c0), bernoulli_lpmf(y | eta_n)) = bernoulli_lpmf(y | pi_c * eta_c0 + (1 - pi_c) * eta_n)` for binary `y`. Added the explicit density-neutral prior `pi_c ~ uniform(0, 1)` for the already bounded parameter `pi_c`. No new observation values were invented; the generated data are deterministic reshapes of the supplied data.
