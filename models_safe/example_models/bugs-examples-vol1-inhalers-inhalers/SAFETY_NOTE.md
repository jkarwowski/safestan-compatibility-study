# SafeStan Safety Note

Compatibility: major.

Protected data choice: the modelled observations are the individual ordered-category `response` values, which the original program constructs in `transformed data` from the contingency-table inputs `Ncum` and `pattern`. A SafeStan rewrite would need these observations as a top-level protected data variable, observed once with a plain sampling statement.

Generated files: none.

Reason: the original likelihood is not in SafeStan form because `response[i, t] ~ categorical(...)` scores a transformed-data variable inside loops rather than a top-level protected data variable. That part could in principle be mechanically rewritten by expanding the contingency table to top-level data and vectorizing the categorical likelihood. However, the parameter `a` is an unbounded `ordered[Ncut]` parameter used in the likelihood with no prior sampling statement. SafeStan requires every parameter to have exactly one built-in prior before use. Adding a proper prior for `a` would change the posterior/log density, so this cannot be translated with only minor same-density changes.
