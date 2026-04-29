# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y1`, `y2`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observations are top-level data variables and are each observed exactly once with plain built-in binomial sampling statements. Context inputs `N1` and `N2` are used only as binomial trial counts. Parameters `theta1` and `theta2` each have exactly one built-in prior before being used in the likelihood.
