# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The model contains no observed data likelihood; `N`, `ts`, and `x_left` are context inputs only and are not scored by sampling statements.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only sampling statement is the built-in prior `xs_forward_ncp ~ normal(0, 1)` for the top-level parameter, and there are no protected observations or forbidden manual log-density operations.
