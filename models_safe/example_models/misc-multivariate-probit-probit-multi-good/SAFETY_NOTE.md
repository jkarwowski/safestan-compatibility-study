# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is implemented by branching on individual observations and adding manual Jacobian/log-likelihood terms with `target += log(bound)` and `target += log1m(bound)`. SafeStan forbids arbitrary `target +=` scoring and also requires protected observations to be scored exactly once by a built-in distribution before they are otherwise inspected. Replacing this GHK-style multivariate probit construction with SafeStan sampling statements would require a substantive likelihood/model rewrite rather than a minor mechanical translation.
