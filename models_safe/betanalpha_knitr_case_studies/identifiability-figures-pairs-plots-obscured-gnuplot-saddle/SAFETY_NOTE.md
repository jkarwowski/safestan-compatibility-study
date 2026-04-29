# SafeStan Safety Note

Compatibility: major.

Protected data: none. The program has no top-level data block and no observed data likelihood.

Generated files: none.

Reason: the model is defined by a custom manual `target +=` joint log density over parameters `x`, `y`, and `z`. SafeStan forbids arbitrary target increments and requires each parameter to be introduced by exactly one built-in prior sampling statement before use. The nonlinear coupled density term involving both `x` and `y`, together with the additional `y` quadratic term, cannot be represented as the same density using only one built-in sampling statement per parameter without a substantive model rewrite or density change.
