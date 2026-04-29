# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. `N` is a context input used only to size arrays and construct deterministic transformed data; no top-level data variable is observed with a sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The parameter `x` has a single built-in prior sampling statement, and there are no protected observations or forbidden log-density manipulations.
