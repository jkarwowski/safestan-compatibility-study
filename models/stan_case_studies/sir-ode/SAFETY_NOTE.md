# SafeStan Safety Note

Compatibility: minor.

Protected data: `stoi`, `B`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the ODE solve and derived `y_diff` calculation from `transformed parameters`/early model statements to occur inside the `model` block after the existing explicit priors. The likelihood remains the same and the protected observations are still top-level data observed with plain vectorized sampling statements. No data fields were added or changed.
