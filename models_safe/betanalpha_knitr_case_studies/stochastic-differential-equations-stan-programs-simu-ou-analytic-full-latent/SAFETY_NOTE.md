# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program contains no model block likelihood and no sampling statement conditioning on top-level data; `N` and `t` are context inputs for generated quantities only.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. There are no parameters requiring priors, no protected observations requiring scoring, and no forbidden direct log-density manipulation.
