# SafeStan Safety Note

Compatibility: major.

Protected data: `calls`.

Generated files: none.

Reason: the observed call vector is scored only through manual `bernoulli_lpmf(...)` terms inside a marginalized finite-state calculation and a final `target += log_sum_exp(lp)`. SafeStan forbids arbitrary `target +=` scoring and requires protected observations to appear exactly once on the left side of a built-in sampling statement. A same-density SafeStan version would require substantially replacing the marginalized burglary/earthquake/alarm likelihood, for example by recoding the call vector as a categorical observation with an explicitly computed marginal probability vector, which is beyond a minor mechanical rewrite.
