# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that each parameter prior (`a`, `b`, and `sigma`) appears before the likelihood statement that uses those parameters. This preserves the same Stan log density because sampling statements are additive. `N` and `x` remain unprotected context inputs.
