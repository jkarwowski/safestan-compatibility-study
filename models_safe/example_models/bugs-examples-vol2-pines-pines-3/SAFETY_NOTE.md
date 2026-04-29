# SafeStan Safety Note

Compatibility: major.

Protected data: the model scores `y_std`, a transformed-data quantity deterministically computed from top-level data `y`; no SafeStan protected top-level data variable can be chosen without a substantive rewrite.

Generated files: none.

Reason: the likelihood is applied to `y_std` twice, but `y_std` is not top-level data and is computed from `y` in `transformed data` before any observation statement. Making this SafeStan-compatible would require promoting a standardized transformation of `y` to protected data and duplicating it for the two likelihood factors, which goes beyond a deterministic copy/reshape of the supplied data interface. The program also contains generated-quantities `_lpdf` calls that are outside the SafeStan subset. A same-density minor rewrite preserving the original protected interface is therefore not available.
