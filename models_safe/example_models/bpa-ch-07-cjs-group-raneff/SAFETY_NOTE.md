# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (the capture-history observations). The variables `nind`, `n_occasions`, `g`, and `group` are context inputs.

Generated files: none.

Reason: the likelihood scores indexed elements `y[i, t]` inside loops and an `if` whose bounds are derived from `y` via `first` and `last` in `transformed data`. SafeStan requires each protected observation to be a top-level identifier scored exactly once outside loops and before any other use. The model also contains likelihood factors written as `1 ~ bernoulli(...)`, which score constant events rather than top-level data variables. Making this SafeStan-compatible would require a substantive refactor of the CJS capture-history likelihood into a new protected event interface or another custom marginalized representation, not a minor same-density syntactic rewrite.
