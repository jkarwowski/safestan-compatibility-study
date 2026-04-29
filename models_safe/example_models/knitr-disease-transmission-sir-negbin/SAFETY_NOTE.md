# SafeStan Safety Note

Compatibility: as-is.

Protected data: `cases`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only top-level data variable scored by a sampling statement is `cases`, and it is observed exactly once with a plain top-level sampling statement using the built-in `neg_binomial_2` distribution. The parameters `beta`, `gamma`, and `phi_inv` each have exactly one built-in prior before the likelihood uses transformed quantities depending on them.
