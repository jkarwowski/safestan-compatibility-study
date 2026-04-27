# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: `y` is the observed sequence likelihood, but it is scored through a marginalized hidden Markov model forward algorithm using direct `categorical_lpmf(...)` calls and a final `target += log_sum_exp(last)` adjustment. Replacing this with SafeStan plain sampling statements would require a substantive hidden-state/model rewrite rather than a small same-density mechanical translation.
