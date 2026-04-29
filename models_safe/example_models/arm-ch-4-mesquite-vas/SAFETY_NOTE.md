# SafeStan Safety Note

Compatibility: major.

Protected data: the original likelihood scores `log_weight`, a transformed-data quantity computed as `log(weight)`. There is no SafeStan-compatible protected top-level observation in the original program as written.

Generated files: none.

Reason: the model cannot be translated with only minor mechanical changes. The likelihood is applied to a transformed-data variable rather than a protected top-level data variable, and the parameters `alpha`, `beta`, and `sigma` have only implicit improper flat priors. SafeStan requires each parameter to have exactly one built-in prior sampling statement before use; adding proper priors would change the posterior/log density. Therefore no same-density SafeStan rewrite is produced.
