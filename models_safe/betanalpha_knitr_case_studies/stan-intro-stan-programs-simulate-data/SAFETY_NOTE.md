# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only top-level data variable, `N`, is a context/configuration input used to size simulated generated quantities. The program contains no model-block likelihood, no protected observations, no parameters requiring priors, and no forbidden direct log-density manipulation.
