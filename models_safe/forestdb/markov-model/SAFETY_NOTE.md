# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_1`, `y_2`, `y_3`, `y_4`, `y_5`, `y_6`, `y_7`, `y_8`, `y_9`, `y_10`, `y_11`, `y_12`, `y_13`, and `y_14`, a scalar unrolling of the original observed sequence `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += categorical_lpmf(...)` likelihood with built-in `categorical` sampling statements. Because SafeStan requires protected observations to be top-level plain identifiers and not be sampled inside loops, the length-14 observed array was deterministically reshaped into scalar fields with `y_k = y[k]`. The transition likelihood is unrolled in sequence, so each state is scored before it is used to select the next transition row. The prior loop for `A` was replaced by the equivalent vectorized statement `A ~ dirichlet(rep_vector(1.0, S))`. The resulting density for the supplied sequence is the same as the original Stan program.
