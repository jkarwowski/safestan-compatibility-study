# SafeStan Safety Note

Compatibility: major.

Protected data: the capture-history data `y` is the observed data scored by the likelihood.

Generated files: none.

Reason: the likelihood is not representable in the SafeStan subset by a minor mechanical rewrite. The model computes `first` and `last` from `y` before observing it, then scores indexed elements `y[i, t]` inside data-dependent loops and conditionals. It also includes likelihood contributions written as constant observations, `1 ~ bernoulli(phi[...])` and `1 ~ bernoulli(chi[...])`, which are not top-level data variables. SafeStan requires protected observations to be top-level identifiers, scored exactly once, outside loops. Making this model SafeStan-compatible would require constructing derived pseudo-observation arrays and re-expressing the marginalized Cormack-Jolly-Seber likelihood, which is a substantive rewrite rather than a same-density syntactic translation.
