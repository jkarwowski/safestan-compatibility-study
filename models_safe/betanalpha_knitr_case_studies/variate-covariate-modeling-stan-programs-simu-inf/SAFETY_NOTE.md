# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The declared data variables `N1` and `N2` are context inputs used only as sizes for generated quantities.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no model-block likelihood, no protected observations, and no parameters requiring priors; the generated-quantities RNG code does not condition on observed data.
