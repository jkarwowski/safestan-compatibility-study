# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program does not observe or score any top-level data variable; `N` is only a context/configuration input used to size generated quantities.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program contains no model-block likelihood, no parameters requiring priors, and no forbidden direct log-density manipulation.
