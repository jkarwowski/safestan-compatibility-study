# SafeStan Safety Note

Compatibility: major.

Protected data: `watched`.

Generated files: none.

Reason: the likelihood observes the top-level data variable `watched` with a built-in normal sampling statement, while `N` and `encouraged` are context inputs. However, the parameters `beta` and `sigma` have no explicit priors and are used directly in the likelihood. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding proper priors would change the posterior/log density, and these parameters do not have finite bounds that would allow an exactly density-neutral `uniform(lower, upper)` rewrite. Therefore this model cannot be translated to SafeStan with only minor same-density changes.
