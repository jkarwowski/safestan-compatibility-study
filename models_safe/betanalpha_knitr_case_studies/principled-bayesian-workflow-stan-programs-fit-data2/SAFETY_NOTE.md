# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observational model is a zero-inflated Poisson likelihood implemented with manual `target +=` increments, `log_mix`, and a data-dependent branch on `y[n]`. SafeStan forbids arbitrary target manipulation, and there is no equivalent built-in Stan sampling statement for this zero-inflated likelihood. Replacing it would require a substantive model rewrite rather than a minor same-density translation.
