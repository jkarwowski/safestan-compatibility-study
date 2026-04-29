# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observational model for `y` is implemented with manual `target +=` terms inside a loop, including a data-dependent branch and `log_mix` for a zero-inflated truncated Poisson likelihood. SafeStan forbids arbitrary `target +=` scoring, and replacing this likelihood with SafeStan sampling statements would require a substantive model rewrite or a custom/user-defined distribution rather than a minor same-density translation.
