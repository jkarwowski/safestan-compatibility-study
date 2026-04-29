# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the hierarchical scale priors so `delta_factor1_tau` and `delta_factor2_tau` are sampled before they are used as scale parameters in downstream priors. This satisfies SafeStan's parameter-use discipline and preserves the same posterior density. No data changes were made; `log_rho_I`, sizes, indices, and factor mappings remain context inputs.
