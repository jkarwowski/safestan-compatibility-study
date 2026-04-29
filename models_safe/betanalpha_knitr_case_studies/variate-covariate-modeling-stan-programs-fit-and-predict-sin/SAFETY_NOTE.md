# SafeStan Safety Note

Compatibility: minor.

Protected data: `y1`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added an explicit `phi ~ uniform(0, 2 * pi())` prior so that every parameter has exactly one built-in prior sampling statement before use. This makes the original finite-bounded implicit uniform prior for `phi` explicit for SafeStan. No data fields were added or changed.
