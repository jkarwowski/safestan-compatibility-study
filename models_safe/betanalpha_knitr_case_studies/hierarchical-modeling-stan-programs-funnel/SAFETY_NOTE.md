# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The only top-level data variable, `K`, is a context input used only to size the parameter array.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model has no observed data likelihood; both top-level parameters are assigned exactly one built-in prior sampling statement before any later use (`tau ~ normal(0, 5)` and `phi ~ normal(0, tau)`).
