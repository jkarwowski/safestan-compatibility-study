# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `phi ~ uniform(-1, 1);` because `phi` is a finite-bounded parameter with an implicit uniform prior in the original model but SafeStan requires every top-level parameter to have exactly one built-in prior sampling statement before use. No data changes were required; `y` is already a top-level data variable and is observed exactly once with a built-in sampling statement.
