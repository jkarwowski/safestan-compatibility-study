# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (the response array scored by the partial-credit-model likelihood).

Generated files: none.

Reason: the likelihood for `y` is implemented as per-observation manual `target += pcm(...)` scoring inside a loop, with `pcm` a user-defined log-probability helper calling `categorical_lpmf` using item-specific probabilities. SafeStan requires a protected top-level data variable to be scored exactly once on the left side of a built-in sampling statement, not through `target +=`, a user-defined likelihood helper, or looped elementwise scoring. Replacing this generalized partial credit likelihood with SafeStan-compatible built-in sampling would require a substantive likelihood/interface rewrite rather than a minor mechanical translation.
