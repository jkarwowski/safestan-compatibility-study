# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The only top-level data variable, `N`, is a context size used to determine generated-quantities dimensions and loop bounds; it is not observed with a sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model block contains no likelihood or prior sampling statements, no parameters, and no forbidden direct log-density manipulation.
