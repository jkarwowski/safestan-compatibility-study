# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The program does not observe any top-level data variable with a sampling statement; `M`, `N`, `x0`, and `X` are context inputs only.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the explicit `reject("")` gate enforcing `0 <= alpha + deltaX[n,] * beta <= 1` for every observation with a constrained transformed parameter `p = alpha + deltaX * beta` declared as `vector<lower=0, upper=1>[N]`. This preserves the same parameter support and unnormalized density while removing the forbidden `reject()` call. `data_safe.json` is unchanged.
