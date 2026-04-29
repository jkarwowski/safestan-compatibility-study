# SafeStan Safety Note

Compatibility: major.

Protected data: `likelihood` is the only top-level data variable entering the manual likelihood contribution; `H` and `N` are sizes.

Generated files: none.

Reason: the model uses `target += log_sum_exp(...)` to add a marginalized mixture-style likelihood involving `likelihood` and `hypothesis_weight`. SafeStan forbids arbitrary `target +=` scoring, and the same log density cannot be represented as a single built-in sampling statement for the existing top-level data without inventing an additional observed variable or substantially rewriting the likelihood. Therefore this is not a minor SafeStan translation.
