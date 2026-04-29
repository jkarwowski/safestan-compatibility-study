# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The Stan program does not score any top-level data variable with a sampling statement; all data variables are context inputs or unused.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model contains only built-in prior sampling statements for the four parameters, each parameter is sampled exactly once before any generated-quantities use, and there is no arbitrary log-density manipulation.
