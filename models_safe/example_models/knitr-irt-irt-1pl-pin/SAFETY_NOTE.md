# SafeStan Safety Note

Compatibility: major.

Protected data choice: the original observed response array `y`.

Generated files: none.

Reason: the likelihood observes slices/elements of `y` inside a loop (`head(y[i], J - 1) ~ ...` and `y[i, J] ~ ...`), which is not directly SafeStan-compatible. That part could potentially be handled by deterministic top-level copies/reshapes, but the model also has unconstrained parameters `b` and `theta` with no explicit built-in priors. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors to these unconstrained parameters would change the posterior/log density, so a SafeStan translation would require a substantive model change rather than a minor mechanical rewrite.
