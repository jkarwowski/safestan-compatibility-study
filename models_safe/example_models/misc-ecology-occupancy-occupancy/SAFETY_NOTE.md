# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed detection histories `y` are scored through manual `target +=` statements inside a loop, with a data-dependent branch on `sum(y[r])`. SafeStan forbids direct `target +=` scoring and also requires protected observations to be scored exactly once by a built-in distribution before any other use. The likelihood is a marginalized occupancy/latent-state likelihood using `log_sum_exp`; replacing it with SafeStan sampling statements would require a substantive rewrite of the likelihood representation rather than a minor mechanical translation.
