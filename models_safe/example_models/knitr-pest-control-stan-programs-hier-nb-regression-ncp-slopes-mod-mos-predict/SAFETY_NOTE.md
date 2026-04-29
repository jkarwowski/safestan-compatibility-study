# SafeStan Safety Note

Compatibility: as-is.

Protected data: `complaints`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only top-level data variable observed with a sampling statement is `complaints`, and it is scored exactly once with the built-in `neg_binomial_2_log` distribution using a plain top-level left-hand side. All top-level parameters have exactly one built-in prior sampling statement before their transformed-parameter dependencies are used in the model likelihood. Other data variables are context inputs used as predictors, sizes, indices, or generated-quantities inputs.
