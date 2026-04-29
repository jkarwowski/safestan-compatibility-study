# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered two parameter prior statements so that `b_v_prev` and `b_region` are sampled before `b_state ~ normal(b_state_hat, sigma_state)`. The transformed parameter `b_state_hat` depends on `b_v_prev` and `b_region`, so SafeStan requires their priors to appear before that use. This is a same-density reordering of factors in the model block. No data fields were changed.
