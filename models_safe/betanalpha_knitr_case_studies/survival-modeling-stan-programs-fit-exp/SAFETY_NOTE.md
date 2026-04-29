# SafeStan Safety Note

Compatibility: as-is.

Protected data: `obs_times`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `obs_times` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. The parameter `gamma` has exactly one built-in prior before it is used in the likelihood. `N` is retained as an unprotected context input.
