# SafeStan Safety Note

Compatibility: minor.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: no top-level data variable is observed with a sampling statement, so all data variables are context inputs and the protected interface is empty. The model block was reordered so that hierarchical scale parameters (`delta_factor1_tau` and `delta_factor2_tau`) receive their built-in priors before being used as scales in other parameter priors. This is a same-density mechanical change; no data values or likelihood terms were changed.
