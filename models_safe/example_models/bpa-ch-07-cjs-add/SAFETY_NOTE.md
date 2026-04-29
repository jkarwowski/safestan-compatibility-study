# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the observed capture-history data variable that the likelihood conditions on.

Generated files: none.

Reason: the capture-recapture likelihood cannot be represented by a minor SafeStan rewrite. The model computes `first` and `last` from `y` in `transformed data`, then uses indexed elements `y[i, t]` inside loops and an `if` condition, while SafeStan requires each protected top-level data variable to be observed exactly once with a plain built-in sampling statement before any other use. The likelihood also contains pseudo-observation terms such as `1 ~ bernoulli(phi[i, t - 1])` and `1 ~ bernoulli(chi[i, last[i]])`, which are not top-level protected data variables. Replacing this marginalized CJS likelihood with SafeStan-compatible built-in sampling statements would require a substantive model rewrite or adding new observed data, so no same-density minor translation is provided.
