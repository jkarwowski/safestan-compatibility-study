# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program does not score any top-level data variable with a sampling statement; all data variables (`N`, `ts`, `x_left`, `x_right`, `left_idxs`, `center_idxs`, and `right_idxs`) are context inputs.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only sampling statement is the built-in prior `interior_x_tildes ~ normal(0, 1)` for the top-level parameter, and there is no protected likelihood interface in this prior-only program.
