# SafeStan Safety Note

Compatibility: major.

Protected data: `log_lik` is the data object entering the likelihood contribution.

Generated files: none.

Reason: the model uses manual `target += log_sum_exp(...)` scoring to add a marginalized finite-state likelihood from the precomputed `log_lik` matrix. SafeStan forbids arbitrary `target +=` scoring, and there is no same-density mechanical rewrite to a single built-in sampling statement for the protected data without substantially changing the model/interface or introducing a different likelihood representation.
