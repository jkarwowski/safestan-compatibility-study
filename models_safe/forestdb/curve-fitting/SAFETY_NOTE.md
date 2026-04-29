# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized finite mixture implemented with manual `target += log_sum_exp(...)` scoring over `normal_lpdf(y[n] | rule_pred[r, n], sigma)` terms. SafeStan forbids `target +=` and requires protected observations to be scored exactly once by a built-in sampling statement with the protected top-level data variable on the left. There is no equivalent built-in Stan sampling statement for this weighted normal mixture, and replacing the marginalized mixture with latent discrete rule indicators or a continuous relaxation would be a substantive model change rather than a minor same-density rewrite.
