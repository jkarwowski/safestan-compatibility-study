# SafeStan Safety Note

Compatibility: major.

Protected data: the model scores `y`, but `y` is defined in `transformed data` rather than as a top-level data variable; no valid SafeStan protected interface is generated.

Generated files: none.

Reason: SafeStan requires scored observations to be top-level protected data variables and requires every parameter to have exactly one built-in prior before use. Although the fixed vector `y` could in principle be moved mechanically to a data block, the parameter `mu` has only Stan's implicit improper flat prior. Adding a proper built-in prior for `mu` would change the posterior/log density, so this model cannot be translated to SafeStan with only a minor same-density rewrite.
