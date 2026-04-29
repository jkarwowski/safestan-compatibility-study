# SafeStan Safety Note

Compatibility: major.

Protected data: `x`.

Generated files: none.

Reason: the likelihood for `x` is a custom composite lognormal-Pareto density implemented by manually accumulating `target += sum(lpa)`, with per-observation branches depending on both `theta` and `x[i]`. SafeStan forbids direct `target +=` scoring and requires protected observations to be scored exactly once by a built-in distribution with a plain top-level left-hand side. Replacing this custom, piecewise likelihood with SafeStan sampling statements would require a substantive likelihood/model rewrite rather than a minor same-density translation.
