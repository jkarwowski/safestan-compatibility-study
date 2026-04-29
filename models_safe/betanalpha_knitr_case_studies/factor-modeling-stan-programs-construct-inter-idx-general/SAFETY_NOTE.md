# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The program contains no model-block sampling statements and no top-level data variable is observed/scored as a likelihood term.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: removed the two `reject(...)` calls from `transformed data`, because SafeStan forbids `reject()`/`fatal_error()` constructs. These statements were deterministic data-validation guards only; there are no parameters, priors, likelihood terms, or protected observations in this program. The supplied JSON data were preserved unchanged and no fields were added.
