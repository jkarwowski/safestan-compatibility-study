# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y_obs` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. The parameter `f_tilde` has exactly one built-in prior before its transformed value is used in the likelihood. Other data variables are context inputs used as sizes, indices, constants, or covariance inputs.
