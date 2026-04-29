# SafeStan Safety Note

Compatibility: major.

Protected data: `grade` (the observed, non-missing response entries).

Generated files: none.

Reason: the likelihood is implemented with manual `target += log(...)` scoring inside loops and gated by `if (grade[i, j] != -1)` for missing values. A SafeStan version would require replacing the ragged, missing-value likelihood with a new flattened or padded protected data interface and index structure. That changes the protected interface rather than preserving the original top-level observed variable with a direct built-in sampling statement, so it is not an as-is or minor SafeStan translation of this model.
