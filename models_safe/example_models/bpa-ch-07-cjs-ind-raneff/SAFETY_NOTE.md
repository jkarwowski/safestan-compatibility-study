# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the capture-history data used in the likelihood.

Generated files: none.

Reason: the likelihood is not SafeStan-compatible in a way that can be repaired by a minor mechanical rewrite. The model computes `first` and `last` from `y` in `transformed data` before the observation is scored, observes indexed elements `y[i, t]` inside data-dependent loops and conditionals, and also scores literal constants with `1 ~ bernoulli(...)`. SafeStan requires each protected top-level data variable to be observed exactly once with a plain built-in sampling statement before any other use, and protected observation statements cannot occur inside loops. Converting this Cormack-Jolly-Seber marginalized capture-history likelihood into a single top-level built-in observation statement would require a substantive reformulation of the likelihood/interface rather than a small same-density rewrite.
