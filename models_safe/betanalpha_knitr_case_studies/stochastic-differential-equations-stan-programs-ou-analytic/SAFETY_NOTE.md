# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The original program does not score any top-level data variable with a sampling statement; `N`, `t`, `x0`, `mu`, `gamma`, and `tau` are context inputs.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the loop of scalar normal transition priors over transformed-parameter elements with one built-in `multi_normal_cholesky` prior on the top-level parameter `x_free`. The Cholesky factor is computed deterministically from the same OU transition coefficients and innovation scales, preserving the exact joint density implied by the original product of transition densities. `x_free` was changed from `array[N] real` to `vector[N]` so it can be sampled as a plain top-level parameter variable; the transformed parameter `x` is reconstructed deterministically. `data_safe.json` is unchanged.
