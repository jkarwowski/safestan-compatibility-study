# SafeStan Safety Note

Compatibility: minor.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added an explicit `x_tilde ~ uniform(0, 1)` prior. The original model relied on the implicit uniform density from the finite `<lower=0, upper=1>` constraint on `x_tilde`; the explicit uniform prior has log density zero on the constrained support, so this is a same-density mechanical rewrite that satisfies SafeStan's requirement that each parameter have exactly one built-in prior sampling statement.
