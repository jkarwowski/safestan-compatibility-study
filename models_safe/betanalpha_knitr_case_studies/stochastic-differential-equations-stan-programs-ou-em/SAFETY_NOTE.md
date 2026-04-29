# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The original program has no top-level data variable on the left side of a sampling statement; `N`, `t`, `x0`, `mu`, `gamma`, and `tau` are context inputs.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the loop of conditional normal sampling statements for the latent path with a single built-in `multi_normal` prior for the top-level parameter `x_free`. The multivariate normal mean and covariance are computed deterministically from the context data and are exactly the joint Gaussian distribution implied by the original linear Euler-Maruyama transitions. `x_free` is declared as a `vector[N]` so it can be the plain top-level left-hand side of `multi_normal`; the transformed parameter `x` is reconstructed deterministically. The data file is unchanged.
