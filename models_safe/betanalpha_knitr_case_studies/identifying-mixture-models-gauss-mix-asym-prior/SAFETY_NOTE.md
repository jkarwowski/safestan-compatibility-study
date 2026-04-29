# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: `y` is scored through a marginalized two-component Gaussian mixture implemented with manual `target += log_mix(...)` and `normal_lpdf(...)` terms inside a loop. SafeStan forbids direct `target +=` scoring and does not allow replacing this with a user-defined likelihood. A SafeStan translation would require a substantive likelihood/model rewrite rather than a minor same-density mechanical change.
