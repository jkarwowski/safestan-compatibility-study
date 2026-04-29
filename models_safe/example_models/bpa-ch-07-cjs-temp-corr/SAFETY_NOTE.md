# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the capture-history likelihood is a marginalized CJS likelihood with data-dependent first/last capture logic. The protected observation `y` is inspected in `transformed data` to compute `first` and `last` before it is scored, and the likelihood scores indexed elements `y[i, t]` inside data-dependent loops rather than scoring a top-level protected variable exactly once. The model also uses hard-coded sampled constants such as `1 ~ bernoulli(phi[i, t - 1])` and `1 ~ bernoulli(chi[i, last[i]])`, and has parameter-prior statements inside loops plus implicit uniform priors. Converting this to SafeStan would require a substantive re-encoding of the capture-recapture likelihood or pseudo-observation interface, not a minor same-density syntactic rewrite.
