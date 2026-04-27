# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized two-component normal mixture implemented with manual `target += log_mix(...)` scoring and direct `normal_lupdf` calls. Replacing this with SafeStan plain sampling statements would require a substantive mixture-model rewrite rather than a small same-density mechanical translation.
