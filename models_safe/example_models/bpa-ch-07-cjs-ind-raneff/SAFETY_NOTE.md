# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the capture-history data scored by the likelihood.

Generated files: none.

Reason: the likelihood for `y` is a Cormack-Jolly-Seber capture-history likelihood assembled from indexed Bernoulli sampling statements inside data-dependent loops and conditionals, plus additional Bernoulli factors with literal `1` on the left-hand side for survival and terminal non-recapture probabilities. SafeStan requires protected observations to be top-level identifiers scored exactly once outside loops and forbids sampling statements on literals or indexed data. Although the finite-bounded parameters could receive explicit uniform priors mechanically, representing this likelihood under SafeStan would require a substantive restructuring of the capture-history likelihood into a different protected data interface or custom marginalized form, not a minor same-density syntactic rewrite.
