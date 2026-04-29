# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model scored indexed rows `y[i]` inside a loop, which SafeStan does not allow for protected observations. The safe model deterministically reshapes `y` to a length `I * J` array in row-major order, constructs the matching vector of logits after the parameter priors, and scores `y` exactly once with `y ~ bernoulli_logit(eta)`. For the supplied data, the original `[[0, 1, 0], [0, 0, 1]]` becomes `[0, 1, 0, 0, 0, 1]`; in general, new `y[(i - 1) * J + j]` equals original `y[i, j]`. This preserves the same summed Bernoulli-logit likelihood, and the priors for `theta` and `b` were already explicit built-in distributions.
