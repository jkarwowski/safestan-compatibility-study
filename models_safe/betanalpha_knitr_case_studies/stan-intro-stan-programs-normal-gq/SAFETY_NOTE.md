# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The only top-level data variable, `N`, is a context/configuration input used as a size and is not observed with a sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the two parameter sampling statements in the `model` block so that `theta` receives its built-in prior before it is used in the prior for `y`. This is a mechanical same-density change because the joint log density contributions are unchanged, only their order is different.
