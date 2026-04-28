# SafeStan Safety Note

Compatibility: minor.

Protected data: `calls_state`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the original binary array observation `calls` with the deterministic categorical encoding `calls_state = 1 + 2 * calls[1] + calls[2]`, so `[0, 0] -> 1`, `[0, 1] -> 2`, `[1, 0] -> 3`, and `[1, 1] -> 4`. For the supplied data `[1, 1]`, this gives `calls_state = 4`. The manual marginalized likelihood implemented with `target += log_sum_exp(...)` and `_lpmf` calls was rewritten as the equivalent normalized built-in statement `calls_state ~ categorical(probs)`, where `probs` is computed from the same burglary/earthquake/alarm network. Generated quantities were rewritten with equivalent probability arithmetic and no `_lpmf` calls. Parameter priors are unchanged.
