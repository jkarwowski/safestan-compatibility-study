# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized two-component Gaussian mixture implemented with manual `target += log_mix(...)` scoring and elementwise `normal_lpdf` calls. SafeStan forbids arbitrary `target +=` scoring, and there is no equivalent built-in sampling statement for this marginalized mixture with `y` as a plain top-level left-hand-side observation. Rewriting it would require a substantive model/likelihood change, so no SafeStan-compatible minor translation is produced.
