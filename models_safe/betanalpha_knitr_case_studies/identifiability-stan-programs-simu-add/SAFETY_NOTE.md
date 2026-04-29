# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no model-block likelihood sampling statement for any top-level data variable, no parameters requiring priors, and no forbidden direct log-density manipulation. `N` is a context input used only to size generated quantities.
