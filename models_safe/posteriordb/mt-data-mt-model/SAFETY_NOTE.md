# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (the capture-history matrix). `M` and `T` are context inputs.

Generated files: none.

Reason: the likelihood for `y` is implemented with manual `target +=` terms, including a `log_sum_exp(...)` marginalization over the latent inclusion state for all-zero capture histories. SafeStan forbids arbitrary `target +=` scoring, and this zero-inflated/marginalized capture-recapture likelihood is not expressible as a single built-in sampling statement for the top-level protected variable `y` without a substantive model rewrite. The transformed-data use of `y` to compute `s` and `C`, and the implicit uniform priors on bounded parameters, could be handled mechanically, but the marginalized likelihood itself cannot be translated within the SafeStan subset while preserving the same density.
