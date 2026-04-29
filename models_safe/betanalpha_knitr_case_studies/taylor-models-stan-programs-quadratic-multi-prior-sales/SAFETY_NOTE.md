# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The Stan program contains no data likelihood; no top-level data variable appears on the left side of a sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model put priors on individual elements of the vector parameters `beta1`, `beta2_d`, and `beta2_o`. SafeStan requires each top-level parameter to be sampled exactly once, so these elementwise priors were rewritten as equivalent vectorized built-in normal priors. The hard-coded three-covariate prior structure was made explicit by constraining `M` to equal 3, matching the model's indexed prior specification and the supplied data. No observations or data values were added or changed.
