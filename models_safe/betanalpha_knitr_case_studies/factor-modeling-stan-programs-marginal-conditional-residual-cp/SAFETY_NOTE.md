# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered parameter prior sampling statements so that scale parameters `delta_context_tau` and `delta_factor_tau` are observed with their priors before they are used in other parameter priors. This is a same-density mechanical rewrite because Stan model statement order does not change the accumulated posterior density here. No data changes were required.
