# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The only top-level data variable, `N`, is a context/configuration input used to size generated quantities and is not scored by a likelihood.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model block is empty, there are no parameters requiring priors, and the generated-quantities RNG code does not condition on protected observations.
