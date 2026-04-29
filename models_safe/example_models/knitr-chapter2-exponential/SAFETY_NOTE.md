# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that all parameter priors (`a`, `b`, and `sigma`) are stated before the likelihood that uses those parameters. This is a density-preserving mechanical change because Stan log-density contributions are additive. No data changes were required; `x` and `N` remain unprotected context inputs.
