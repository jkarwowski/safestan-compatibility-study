# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observations `y[n]` are scored through manual `target +=` terms implementing a zero-inflated truncated Poisson likelihood with data-dependent branching. SafeStan forbids arbitrary `target +=` scoring and requires each protected top-level data variable to be observed exactly once with a built-in sampling statement. There is no equivalent built-in Stan distribution for this marginalized mixture/truncation likelihood, so producing a SafeStan-compatible version would require a substantive likelihood rewrite.
