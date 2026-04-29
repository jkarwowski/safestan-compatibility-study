# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observes the top-level data variable `y` with a built-in normal sampling statement, while `N` and `sigma` are context inputs. However, parameters `a` and `b` have only implicit improper flat priors and are used in the likelihood before any SafeStan-recognized prior sampling statement. Adding proper priors would change the posterior/log density, and replacing the flat improper priors is not a minor same-density rewrite.
