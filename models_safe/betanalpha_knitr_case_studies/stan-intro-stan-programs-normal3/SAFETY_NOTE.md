# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The only data variable, `N`, is a context size and is not scored by a sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the two parameter sampling statements so that `theta` is given its built-in prior before it is used in the prior for `y`. This preserves the same joint density because the original sampling statements contribute additively to the log density.
