# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program is prior-only with respect to data: no top-level data variable appears on the left side of a sampling statement. The declared `cases` data are not scored by the model.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model uses only built-in sampling statements for top-level parameters, each parameter has exactly one prior, and there is no protected observed likelihood to rewrite.
