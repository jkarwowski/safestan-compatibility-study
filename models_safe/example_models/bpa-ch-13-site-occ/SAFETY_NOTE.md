# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the model conditions on the observation matrix `y` through a marginalized site-occupancy likelihood. The likelihood uses `y` in `transformed data` to compute detection summaries, branches on those summaries, scores detected histories with indexed sampling statements inside a loop, and scores all-zero histories with a manual `target += log_sum_exp(...)` mixture term. SafeStan forbids manual `target +=` scoring and requires each protected observation to be scored exactly once by a built-in distribution using a plain top-level left-hand side before any other use. Replacing this marginalized occupancy likelihood with SafeStan sampling statements would require a substantive model rewrite or a different likelihood representation, not a minor same-density translation.
