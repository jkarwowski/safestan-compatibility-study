# SafeStan Safety Note

Compatibility: major.

Protected data: `X`.

Generated files: none.

Reason: the capture-history likelihood for `X` is implemented through manual `target +=` terms, with `X` also inspected in `transformed data` to compute first/last capture summaries. SafeStan forbids arbitrary `target +=` scoring, and representing this marginalized Cormack-Jolly-Seber likelihood with a single built-in sampling statement for the protected top-level observation would require a substantive model rewrite rather than a minor mechanical translation.
