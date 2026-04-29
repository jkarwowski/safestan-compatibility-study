# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (the capture-history data are the observed interface used by the likelihood).

Generated files: none.

Reason: the likelihood is a marginalized capture-recapture/state-survival likelihood whose scoring is split across indexed observations `y[i, t] ~ bernoulli(...)`, constant pseudo-observations `1 ~ bernoulli(...)`, data-dependent loops/conditionals using `first` and `last`, and the recursively computed `chi` term. SafeStan requires protected observations to be top-level variables scored exactly once with a plain built-in sampling statement outside loops, and sampling statements may not target constants. Replacing this with SafeStan-compatible top-level likelihood statements would require a substantive reparameterization/augmentation of the marginalized likelihood rather than a minor mechanical rewrite. The implicit bounded uniform priors on `alpha` and `beta` could be made explicit, but that does not address the likelihood incompatibility.
