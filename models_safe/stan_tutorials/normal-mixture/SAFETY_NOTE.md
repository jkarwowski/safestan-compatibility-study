# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized two-component normal mixture implemented with manual `target += log_mix(...)` scoring and built-in `_lupdf` calls. SafeStan forbids arbitrary `target +=` likelihood contributions and requires protected observations to be scored exactly once by a built-in sampling statement. Replacing this marginalized mixture with SafeStan-compatible sampling statements would require a substantive model rewrite, such as introducing latent component indicators or changing the likelihood representation, so no minor same-density translation is available.
