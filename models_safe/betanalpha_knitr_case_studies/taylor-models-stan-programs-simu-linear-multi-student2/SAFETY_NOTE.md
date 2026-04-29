# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program does not condition on any top-level data variable with a sampling statement; `x0` is a context input used only to generate simulated quantities.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model contains no parameters, no model-block likelihood, and no forbidden direct target manipulation. The generated-quantities RNG simulation is preserved unchanged.
