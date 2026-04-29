# SafeStan Safety Note

Compatibility: major.

Protected data choice: candidate protected response is `y`, which is scored only indirectly through the transformed-data value `y_std`. `x`, `z`, and `N` are context inputs.

Generated files: none.

Reason: the model builds the posterior density manually with `target +=` statements applied to `log_joint`, which contains built-in `_lpdf` calls. More importantly, the observed response is standardized in `transformed data` before any observation statement, and the transformed response `y_std` is then included in two separate normal likelihood factors. SafeStan requires protected top-level data to be observed exactly once with a plain built-in sampling statement before any other use. Replacing this with SafeStan sampling statements would require changing the protected interface to derived/duplicated standardized observations or otherwise changing the likelihood, which is not a minor same-density translation.
