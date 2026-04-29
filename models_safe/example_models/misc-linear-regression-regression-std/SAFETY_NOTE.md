# SafeStan Safety Note

Compatibility: major.

Protected data: the likelihood scores `y_std`, a transformed-data standardization of top-level data `y`; there is no SafeStan-compatible top-level protected observation in the original program.

Generated files: none.

Reason: `y_std` is computed from `y` in `transformed data` and then used on the left side of a sampling statement. SafeStan only permits likelihood sampling statements for plain top-level protected data variables. Rewriting this as a likelihood for raw `y`, or hoisting the standardized values as a new protected observation, would change the protected interface and/or require a non-copy deterministic data transform rather than a minor same-density SafeStan translation.
