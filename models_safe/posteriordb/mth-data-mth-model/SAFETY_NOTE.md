# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed capture-history matrix `y` is scored by a marginalized capture-recapture likelihood implemented with manual `target +=` terms, including conditional `log_sum_exp(...)` mixture scoring for all-zero capture histories. SafeStan forbids arbitrary `target +=` scoring, and this row-wise marginalized likelihood is not expressible as a minor same-density rewrite using a single built-in sampling statement on the protected top-level data variable. A SafeStan version would require a substantive model/likelihood rewrite rather than a mechanical translation.
