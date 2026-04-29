# SafeStan Safety Note

Compatibility: minor.

Protected data: `z`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that each parameter prior (`rho`, `alpha`, `a`, and `eta`) is stated before any use of the corresponding parameter in deterministic computations or likelihood terms. This preserves the same posterior/log density. No data changes were required.
