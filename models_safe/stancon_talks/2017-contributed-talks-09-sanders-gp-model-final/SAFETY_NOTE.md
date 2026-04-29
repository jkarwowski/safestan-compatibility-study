# SafeStan Safety Note

Compatibility: minor.

Protected data: `z1`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so every top-level parameter prior sampling statement appears before any use of that parameter. The protected observation `z1` was already a top-level data variable scored exactly once by a built-in distribution with a plain sampling statement. No data fields were added or changed; sampling statement order is density-preserving in Stan because log-density contributions are additive.
