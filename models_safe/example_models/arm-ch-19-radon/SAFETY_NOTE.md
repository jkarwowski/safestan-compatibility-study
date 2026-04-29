# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only observed data variable scored by a sampling statement is the top-level variable `y`, and it is observed exactly once with a plain built-in sampling statement after all parameter priors have been declared. The other data variables (`J`, `N`, and `county`) are context inputs used as sizes/indices and are not protected.
