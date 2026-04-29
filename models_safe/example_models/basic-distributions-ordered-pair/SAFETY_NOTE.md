# SafeStan Safety Note

Compatibility: minor.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit built-in uniform prior sampling statements for `a` and `b` so that each parameter is sampled exactly once as required by SafeStan. The bounds `L` and `H` are transformed-data constants, and both parameters are already constrained to lie within `[L, H]` with the additional ordering constraint `a <= b`; these uniform statements are density-neutral on the original constrained support under Stan's sampling-statement semantics and preserve the original posterior/log density. No data fields were added or changed.
