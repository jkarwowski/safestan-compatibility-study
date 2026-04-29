# SafeStan Safety Note

Compatibility: major.

Protected data: none. The model block does not place any top-level data variable on the left-hand side of a sampling statement; all supplied data variables are used only as context inputs/predictors or configuration.

Generated files: none.

Reason: the program is a Stan compiler regression-test model rather than a SafeStan-compatible likelihood model. It contains constructs rejected by SafeStan, including `_lp` function definitions/calls, `target +=`, `target()`, and `reject()`. The used function `unit_normal_lp(p_real)` adds manual log density and an additional uniform scoring factor for `p_real`, while `p_real` is also sampled with a normal prior. Many other parameter priors are applied through indexed or transformed left-hand sides and inside loops. Rewriting this into SafeStan would require a substantive change to the model density and parameter-prior structure, not a minor same-density translation.
