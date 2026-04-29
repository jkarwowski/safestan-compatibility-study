# SafeStan Safety Note

Compatibility: as-is.

Protected data: `C`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. `C` is the only top-level data variable scored by a sampling statement, and it is observed exactly once with a plain built-in `lognormal` sampling statement. The remaining data variables (`t0`, `C0`, `D`, `V`, `N_t`, and `times`) are context inputs used to construct the ODE prediction. Each parameter has exactly one built-in prior before the likelihood uses the transformed prediction `mu_C`.
