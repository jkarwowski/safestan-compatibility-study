# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the deterministic construction of the local model-block variable `kappa` until after the priors for `baseline` and `alpha`. In the original program, `kappa` used the parameter `baseline` before its prior sampling statement, which violates SafeStan's parameter-use ordering discipline. The rewrite preserves the same posterior density. No data fields were added or changed; `data_safe.json` is the supplied data unchanged.
