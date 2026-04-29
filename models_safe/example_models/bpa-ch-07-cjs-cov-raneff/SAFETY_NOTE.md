# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the capture history `y` is the observed interface, but the likelihood is a data-dependent Cormack-Jolly-Seber marginalized likelihood. The model computes `first` and `last` from `y` in `transformed data`, uses those values to gate likelihood terms, scores indexed elements `y[i, t]` inside nested loops, and also adds likelihood factors through constant observations such as `1 ~ bernoulli(phi[...])` and `1 ~ bernoulli(chi[...])`. SafeStan requires protected observations to be top-level variables scored exactly once with a plain built-in sampling statement before other use, and forbids protected observation statements inside loops. Rewriting this into SafeStan would require a substantive re-expression or preprocessing of the capture-history likelihood rather than a minor same-density syntactic change.
