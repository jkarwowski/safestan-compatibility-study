# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (the capture-history matrix, through the derived row totals `s = sum(y[i])`). `M` and `T` are context inputs.

Generated files: none.

Reason: the likelihood is implemented with manual `target +=` statements inside a loop and data-dependent branch, including a marginalized latent inclusion state via `log_sum_exp(...)` for never-detected individuals. SafeStan forbids direct target manipulation and requires protected top-level observations to be scored exactly once by built-in sampling statements before any other use. Here `y` is also read in `transformed data` before any possible SafeStan observation. Preserving this zero-inflated/marginalized capture likelihood would require a substantive likelihood refactor, such as introducing derived protected summaries or replacing the marginalized latent-state algorithm, rather than a minor mechanical rewrite. The implicit uniform priors on `omega` and `p` could be made explicit, but that does not resolve the unsafe likelihood construction.
