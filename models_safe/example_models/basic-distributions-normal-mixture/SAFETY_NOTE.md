# SafeStan Safety Note

Compatibility: major.

Protected data: none; the model has no top-level data variables and no observed likelihood interface.

Generated files: none.

Reason: the only stochastic density is a two-component normal mixture prior for parameter `y`, implemented with `target += log_mix(...)`. SafeStan forbids manual `target +=` scoring and requires every parameter to have exactly one built-in prior sampling statement before use. Replacing this mixture density with SafeStan-compatible sampling statements would require a substantive model rewrite or a different prior density.
