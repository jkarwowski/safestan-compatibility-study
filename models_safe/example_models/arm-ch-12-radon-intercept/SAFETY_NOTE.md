# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only observed data variable scored by a sampling statement is the top-level variable `y`, which is observed exactly once with the built-in distribution `normal`. Context inputs `N`, `J`, and `county` are not protected because they are used only as sizes/indices. Each parameter has exactly one built-in prior before later model-block use.
