# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y_safestan`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model scored the transformed-data rows `Y[j]` inside a loop. SafeStan requires protected observations to be top-level data variables and to be observed with a plain, non-loop sampling statement. I added `Y_safestan`, the deterministic flattened version of the original transformed-data `Y`: entries `1:I` are all `1`, and entries `(I + 1):(2 * I)` are all `0`. For the supplied data with `I = 6`, this is `[1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]`. The two Poisson-log likelihood statements were vectorized into one `Y_safestan ~ poisson_log(...)` statement. Priors and the deterministic construction of `est` are otherwise unchanged; `n10`, `n01`, `n11`, and `I` remain context inputs.
