# SafeStan Safety Note

Compatibility: minor.

Protected data: `X`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `X_safestan_copy`, a deterministic copy of `X`, because the original program reads `X` in `transformed data` before observing it. The transformed-data calculations now use this copy. The parameter priors and the elementwise truncated normal likelihood were vectorized so that top-level parameters and the protected top-level data variable are each sampled once with built-in distributions and outside loops. The added data field satisfies `X_safestan_copy = X` elementwise.
