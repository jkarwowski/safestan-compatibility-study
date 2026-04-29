# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The program does not score any top-level data variable with a sampling statement; `M`, `N`, `x0`, and `X` are context inputs.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the three indexed component priors `beta[1]`, `beta[2]`, and `beta[3]` as one vectorized built-in normal prior on the top-level parameter `beta`, which preserves the same density for the three slopes. Made the model's existing three-covariate assumption explicit by constraining `M` to equal 3, because the original program hard-codes priors for exactly `beta[1:3]`. No data fields were added or changed.
