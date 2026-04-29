# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model placed the prior `beta ~ normal(0, 10)` on `beta`, a transformed parameter derived from the top-level parameter `beta_tilde`. SafeStan requires priors to be sampling statements on top-level parameters. The safe version uses the equivalent QR parameterization with `beta` as the top-level parameter and defines `beta_tilde = R * beta` as a transformed parameter. This preserves the regression likelihood and the intended prior on `beta` while satisfying SafeStan's parameter-prior discipline. The data file is unchanged.
