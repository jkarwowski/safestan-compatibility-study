# SafeStan Safety Note

Compatibility: major.

Protected data: none; the program has no data block and no observed data likelihood.

Generated files: none.

Reason: the model is a prior-only shape distribution implemented by an explicit `target += log1m(...)` term. SafeStan forbids arbitrary `target +=` scoring and requires each parameter to have exactly one built-in prior sampling statement. The nonstandard density factor depending on `x_raw` cannot be replaced by a minor same-density set of built-in sampling statements; adding uniform priors, especially for `y_raw` with parameter-dependent bounds, would change the density. A SafeStan translation would therefore require a substantive model rewrite.
