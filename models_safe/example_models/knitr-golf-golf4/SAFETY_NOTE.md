# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_rate_safestan`, a deterministic top-level copy of the originally scored expression `to_vector(y) ./ to_vector(n)`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_rate_safestan` to the data block so the likelihood left-hand side is a plain protected top-level identifier, as required by SafeStan. In `data_safe.json`, `y_rate_safestan[j] = y[j] / n[j]` for each `j`. Reordered the parameter prior sampling statements to occur before any model-block use of those parameters. The likelihood and posterior density are otherwise preserved.
